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

@end
