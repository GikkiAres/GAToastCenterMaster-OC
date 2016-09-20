//
//  DefaultActivityView.m
//  GAToastCenterMaster-OC
//
//  Created by GikkiAres on 9/14/16.
//  Copyright © 2016 GikkiAres. All rights reserved.
//

#import "DefaultActivityView.h"

@implementation DefaultActivityView

- (void)awakeFromNib {
  self.layer.cornerRadius = 5;
  self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (instancetype)init
//{
//  self = [super init];
//  if (self) {
//    [self commonInit];
//
//  }
//  return self;
//}
- (instancetype)initWithToastStyle:(GAToastStyle *)style {
  {
    self = [super init];
    if (self) {
      self.frame = CGRectMake(0, 0, 100, 100);
      self.backgroundColor = style.backgroundColor;
      UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
      [indicator startAnimating];
      if (style.shouldActivityViewShowText) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 17)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        label.text = @"正在加载...";
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(50, 75);
        [self addSubview:label];
              indicator.center = CGPointMake(50, 40);
      }
      else {
              indicator.center = CGPointMake(50, 50);
      }
      
      [self addSubview:indicator];


  
    }
    return self;
  }
}


@end
