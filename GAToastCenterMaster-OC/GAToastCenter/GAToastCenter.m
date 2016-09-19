//
//  GAToastCenter.m
//  GAToast-Master
//
//  Created by oftenfull on 16/3/29.
//  Copyright © 2016年 GikkAres. All rights reserved.
//

#import "GAToastCenter.h"

#import <objc/runtime.h>


//关联的关键字
static const NSString * GAActivityViewKey   = @"GAActivityViewKey";
static const NSString * GAProtectorViewKey   = @"GAProtectorViewKey";
static const NSString * GAActivityViewCountKey   = @"GAActivityViewCountKey";
static const NSString * GAMessageViewBlockKey = @"GAMessageViewBlockKey";
static const NSString * GAMessageViewKey = @"GAMessageViewKey";
static const NSString * GAMessageViewQueueKey = @"GAMessageViewQueueKey";
static const NSString * GAMessageViewStyleKey = @"GAMessageViewStyleKey";



@interface GAToastCenter ()



@end

@implementation GAToastCenter

#pragma mark - 1 系统流程
+ (instancetype)defaultCenter {
  static GAToastCenter *_defaultCenter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _defaultCenter = [[GAToastCenter alloc]init];
  });
  return _defaultCenter;
}

- (instancetype)init
{
  self = [super init];
  if (self) {

  }
  return self;
}

#pragma mark - 2 BasicFunc
#pragma mark 2.1 ActivityView的显示和隐藏

+ (void)showActivityViewAtTargetView:(UIView *)view style:(GAToastStyle *)style {
  //判断是否有activity了
  UIView *activityView = objc_getAssociatedObject(view, &GAActivityViewKey);
  if(activityView) {
    NSNumber *activityViewCount = objc_getAssociatedObject(view, &GAActivityViewCountKey);
    NSInteger count = [activityViewCount integerValue];
    count ++;
    activityViewCount = @(count);
  }
  else {
    // 创建view和设置关联
    if (style.isProtectedWhenActivityViewIsShown) {
      UIView *protectorView = [[UIView alloc]initWithFrame:view.bounds];
      [view addSubview:protectorView];
      objc_setAssociatedObject(view, &GAProtectorViewKey, protectorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    UIView *activityView = [self loadDefaultActivityView];
    [view addSubview:activityView];
    objc_setAssociatedObject(view, &GAActivityViewKey, activityView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(view, &GAActivityViewCountKey, @(1), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    
    //1 静态样式调整-    //圆角和阴影
    if(style.isActivityViewUseCenterAppearanceStyle) {
      activityView.layer.cornerRadius = style.cornerRadius;
      
      if (style.displayShadow) {
        activityView.layer.shadowColor = style.shadowColor.CGColor;
        activityView.layer.shadowOpacity = style.shadowOpacity;
        activityView.layer.shadowRadius = style.shadowRadius;
        activityView.layer.shadowOffset = style.shadowOffset;
      }
    }
    //2 alpha动画
    activityView.alpha = 0;
    [UIView animateWithDuration:style.fadeDuration
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                       activityView.alpha = 1;
                     } completion:nil];
    
    // 中心点调整
    activityView.center = [self centerPointForSubview:activityView position:GAToastPositionCenter atTargetView:view];
  }

}

+ (void)showActivityViewAtTargetView:(UIView *)view {
  GAToastStyle *style = [GAToastStyle defaultStyle];
  [self showActivityViewAtTargetView:view style:style];
}

#pragma mark 加载默认ActivityView
+ (UIView *)loadDefaultActivityView {
  UIView *acitivityView = [[[NSBundle mainBundle]loadNibNamed:@"DefaultActivityView" owner:nil options:nil]firstObject];
  return acitivityView;
 }

+ (void)hideActivityViewAtTargetView:(UIView *)view {
   UIView *activityView = objc_getAssociatedObject(view, &GAActivityViewKey);
  if (!activityView) return;
    NSNumber *activityViewCount = objc_getAssociatedObject(view, &GAActivityViewCountKey);
   NSInteger count = [activityViewCount integerValue];
  count --;
  activityViewCount = @(count);
  if(count ==0) {
    GAToastStyle *style = [GAToastStyle defaultStyle];
    [UIView animateWithDuration:style.fadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                       activityView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                       [activityView removeFromSuperview];
                        UIView *protectorView = objc_getAssociatedObject(view, &GAProtectorViewKey);
                       [protectorView removeFromSuperview];
  
                       
                       objc_setAssociatedObject(view, &GAActivityViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                       objc_setAssociatedObject(view, &GAActivityViewCountKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                       objc_setAssociatedObject(view, &GAProtectorViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                       
                     }];
  }

}

#pragma mark 2.2  msg的显示与隐藏.
+ (void)showMessage:(NSString *)msg atTargetView :(UIView *)view {
  GAToastStyle *style = [GAToastStyle defaultStyle];
  [self showMessage:msg atTargetView:view style:style completion:nil];
}

//这个是showMsg系列的最终方法.
+ (void)showMessage:(NSString *)msg atTargetView :(UIView *)targetView  style:(GAToastStyle *)style completion:(void(^)(BOOL isFromTap))completion {
  //参数验证,显示时间少于0就不显示啦
  if(style.showDuration<=0) return;
  
  //总体分为两步,1 生成msgView 2 显示.
   if (!msg||!msg.length) return;
  UIView *messageView = [self messageViewForMessage:msg  style:style atTargetView:targetView];
  
  //如果targetView本身现在已经关联了,且开启了队列显示
  if (style.shouldShowMessageInQueue&&objc_getAssociatedObject(targetView, &GAMessageViewKey) != nil) {
    //关联队列数组
    NSMutableArray<UIView *> *messageViewQueue = objc_getAssociatedObject(targetView, &GAMessageViewQueueKey);
    if (messageViewQueue == nil) {
      messageViewQueue = [[NSMutableArray alloc] init];
      objc_setAssociatedObject(targetView, &GAMessageViewQueueKey, messageViewQueue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    objc_setAssociatedObject(messageView, &GAMessageViewStyleKey, style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [messageViewQueue addObject:messageView];
  } else {
    // 立即显示
  
  [self showMessageView:messageView atTargetView:targetView  style:style completion:completion];
  }
}

#pragma mark 根据msg,和样式生成MessageView.
+ (UIView *)messageViewForMessage:(NSString *)msg style:(GAToastStyle *)style atTargetView:(UIView *)view {
  if (!style) {
    style = [GAToastStyle defaultStyle];
  }
    UIView *msgView = [UIView new];

  //设置样式
    msgView.layer.cornerRadius = style.cornerRadius;
    if (style.displayShadow) {
      msgView.layer.shadowColor = style.shadowColor.CGColor;
      msgView.layer.shadowOpacity = style.shadowOpacity;
      msgView.layer.shadowRadius = style.shadowRadius;
      msgView.layer.shadowOffset = style.shadowOffset;
    }
  msgView.backgroundColor = style.backgroundColor;
  
    UILabel * messageLabel = [[UILabel alloc] init];
    messageLabel.numberOfLines = style.messageNumberOfLines;
    messageLabel.font = style.messageFont;
    messageLabel.textAlignment = style.messageAlignment;
    messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    messageLabel.textColor = style.messageColor;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.alpha = 1.0;
    messageLabel.text = msg;
  CGSize sizeMessageLabel = [messageLabel sizeThatFits:CGSizeMake(view.bounds.size.width * style.maxWidthPercentage-style.horizontalPadding*2, 0) ];
  messageLabel.frame = CGRectMake(style.horizontalPadding, style.verticalPadding, sizeMessageLabel.width, sizeMessageLabel.height);
  CGFloat msgViewWidth = sizeMessageLabel.width+style.horizontalPadding*2;
  CGFloat msgViewHeight = sizeMessageLabel.height+style.verticalPadding*2;
  msgView.frame = CGRectMake(0.0, 0.0, msgViewWidth, msgViewHeight);
  [msgView addSubview:messageLabel];
  return msgView;
}

#pragma mark 显示MessageView,显示messageView的最终方法.
+ (void)showMessageView:(UIView *)messageView atTargetView:(UIView *)targetView style:(GAToastStyle *)style completion:(void(^)(BOOL isFromTap))completion {
    messageView.center = [self centerPointForSubview:messageView position:style.position atTargetView:targetView];
  [targetView addSubview:messageView];
  
  
  //关联MessageView和completion
  objc_setAssociatedObject(messageView, &GAMessageViewBlockKey, completion, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  //关联targetView和messageView
    objc_setAssociatedObject(targetView, &GAMessageViewKey, messageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  
  //是否添加点击手势
    if (style.shouldDismissWhenTapped) {
      UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
      [messageView addGestureRecognizer:gr];
      messageView.exclusiveTouch = YES;
    }
  
  

  
  //alpha动画
  messageView.alpha = 0;
    [UIView animateWithDuration:[style fadeDuration]
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                       messageView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                       NSTimer *timer = [NSTimer timerWithTimeInterval:style.showDuration target:self selector:@selector(onTimer:) userInfo:messageView repeats:NO];
                       [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                     }];
}

+ (void)messageViewRemoveFromTargetView:(UIView *)messageView isFromTap:(BOOL)isFromTap{
    [UIView animateWithDuration:[GAToastStyle defaultStyle].fadeDuration
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                       messageView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                       //移除messageView
                       UIView *targetView = messageView.superview;
                       [messageView removeFromSuperview];
                       
                       //解除关联
                       objc_setAssociatedObject(targetView, &GAMessageViewKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                       

                       
                       // execute the completion block, if necessary
                       void (^completion)(BOOL isFromTap) = objc_getAssociatedObject(messageView, &GAMessageViewBlockKey);
                       if (completion) {
                         completion(isFromTap);
                         objc_setAssociatedObject(messageView, &GAMessageViewBlockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                       }
                       
                       //检查队列中是否还有要show的messageView.
                       NSMutableArray *messageViewQueue = objc_getAssociatedObject(targetView, &GAMessageViewQueueKey);
                       
                       if (messageViewQueue) {
                         if(messageViewQueue.count) {
                           UIView *nextMessageView = messageViewQueue[0];
                           [messageViewQueue removeObjectAtIndex:0];
                           // present the next toast
                           GAToastStyle *style = objc_getAssociatedObject(nextMessageView, &GAMessageViewStyleKey);
                           [self showMessageView:nextMessageView atTargetView:targetView style:style completion:nil];
                         }
                         else  {
                           objc_setAssociatedObject(targetView, &GAMessageViewQueueKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                         }

                       }
                     }];
}


#pragma mark 2.3 工具函数
//返回ActivityFrontView,在activityView中的中心的位置.
+ (CGPoint)centerPointForSubview:(UIView *)frontView position:(GAToastPosition)position atTargetView:(UIView *)view {
  GAToastStyle *style = [GAToastStyle defaultStyle];
  switch (position) {
    case GAToastPositionTop:
       return CGPointMake(view.bounds.size.width/2, (frontView.frame.size.height / 2) + style.verticalPadding);
      break;
      
    case GAToastPositionCenter:
      return CGPointMake(view.bounds.size.width/2, view.bounds.size.height/2);
      break;
      
    case GAToastPositionBottom:
      return CGPointMake(view.bounds.size.width/2, (view.bounds.size.height- frontView.frame.size.height / 2) - style.verticalPadding);
      break;
  }
}

#pragma mark 4 Event
+ (void)onTimer:(NSTimer *)timer {
  [self messageViewRemoveFromTargetView:timer.userInfo isFromTap:NO];
  
}

+ (void)onTap:(UITapGestureRecognizer *)gr {
    [self messageViewRemoveFromTargetView:gr.view isFromTap:YES];
}

@end
