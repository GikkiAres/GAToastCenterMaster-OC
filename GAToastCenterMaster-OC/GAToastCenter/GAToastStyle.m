//
//  GAToastStyle.m
//  GAToast-Master
//
//  Created by oftenfull on 16/3/29.
//  Copyright © 2016年 GikkAres. All rights reserved.
//

#import "GAToastStyle.h"

@implementation GAToastStyle

+ (instancetype)defaultStyle {
  //为什么这里不能写init呢?因为在init函数后面加了NS_UNAVAILABLE
  GAToastStyle *_defaultStyle = [[GAToastStyle alloc]init];
  if (_defaultStyle) {
    //颜色
    _defaultStyle.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    _defaultStyle.messageColor = [UIColor whiteColor];
    //距离
    _defaultStyle.maxWidthPercentage = 0.8;
    _defaultStyle.maxHeightPercentage = 0.8;
    _defaultStyle.horizontalPadding = 10.0;
    _defaultStyle.verticalPadding = 10.0;
    _defaultStyle.cornerRadius = 10.0;
    //字体
    _defaultStyle.messageFont = [UIFont systemFontOfSize:16.0];
    _defaultStyle.messageAlignment = NSTextAlignmentLeft;

    //阴影
    _defaultStyle.displayShadow = YES;
    _defaultStyle.shadowOpacity = 0.8;
    _defaultStyle.shadowRadius = 6.0;
    _defaultStyle.shadowOffset = CGSizeMake(4.0, 4.0);

    //时间
    _defaultStyle.fadeDuration = 0.2;
    _defaultStyle.showDuration = 1;
    
    //其他
    _defaultStyle.isProtectedWhenActivityViewIsShown = YES;
    _defaultStyle.isActivityViewUseCenterAppearanceStyle = YES;
    _defaultStyle.position = GAToastPositionCenter;
    _defaultStyle.shouldDismissWhenTapped = YES;
    _defaultStyle.shouldShowMessageInQueue = YES;

    
  }
  return _defaultStyle;
}


@end
