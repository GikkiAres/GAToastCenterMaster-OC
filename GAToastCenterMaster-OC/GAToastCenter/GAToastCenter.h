//
//  GAToastCenter.h
//  GAToast-Master
//
//  Created by oftenfull on 16/3/29.
//  Copyright © 2016年 GikkAres. All rights reserved.
//

/*
 提示分为两种,网络请求的ActivityView,一般提示的MsgView.
 ActivityView每次显示的toast的style应该分开配置.

*/

#import <UIKit/UIKit.h>
#import "GAToastStyle.h"





@interface GAToastCenter : NSObject

+ (instancetype)defaultCenter;

#pragma mark  1 显示ActivityView,网络请求的提示
//不要加在scrollView上,否则现象有点奇怪.
//#1 最基本的
+ (void)showActivityViewAtTargetView:(UIView *)view style:(GAToastStyle *)style;
+ (void)hideActivityViewAtTargetView:(UIView *)view;
//#2 使用默认的style
+ (void)showActivityViewAtTargetView:(UIView *)view;

#pragma mark 2 显示MessageView
+ (void)showMessage:(NSString *)msg atTargetView:(UIView *)view style:(GAToastStyle *)style completion:(void(^)(BOOL isFromTap))completion;
+ (void)showMessage:(NSString *)msg atTargetView:(UIView *)view completion:(void(^)(BOOL isFromTap))completion;
+ (void)showMessage:(NSString *)msg atTargetView:(UIView *)view;

@end
