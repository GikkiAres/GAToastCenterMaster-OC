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
    _defaultStyle.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.8];
    _defaultStyle.titleColor = [UIColor whiteColor];
    _defaultStyle.messageColor = [UIColor whiteColor];
    _defaultStyle.maxWidthPercentage = 0.8;
    _defaultStyle.maxHeightPercentage = 0.8;
    _defaultStyle.horizontalPadding = 10.0;
    _defaultStyle.verticalPadding = 10.0;
    _defaultStyle.cornerRadius = 10.0;
    _defaultStyle.titleFont = [UIFont boldSystemFontOfSize:16.0];
    _defaultStyle.messageFont = [UIFont systemFontOfSize:16.0];
    _defaultStyle.titleAlignment = NSTextAlignmentLeft;
    _defaultStyle.messageAlignment = NSTextAlignmentLeft;
    _defaultStyle.titleNumberOfLines = 0;
    _defaultStyle.messageNumberOfLines = 0;
    _defaultStyle.displayShadow = NO;
    _defaultStyle.shadowOpacity = 0.8;
    _defaultStyle.shadowRadius = 6.0;
    _defaultStyle.shadowOffset = CGSizeMake(4.0, 4.0);
    _defaultStyle.imageSize = CGSizeMake(80.0, 80.0);
    _defaultStyle.activitySize = CGSizeMake(100.0, 100.0);
    _defaultStyle.fadeDuration = 0.2;
    _defaultStyle.isProtectedWhenActivityViewIsShown = YES;
    _defaultStyle.isActivityViewUseCenterAppearanceStyle = YES;
    _defaultStyle.showDuration = 1;
    _defaultStyle.position = GAToastPositionCenter;
    _defaultStyle.shouldDismissWhenTapped = YES;
    _defaultStyle.shouldShowMessageInQueue = YES;

    
  }
  return _defaultStyle;
}


@end
