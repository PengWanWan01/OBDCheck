//
//  RLBtn.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/3.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "RLBtn.h"

@implementation RLBtn

- (void)layoutSubviews {
    [super layoutSubviews];
       
    CGRect titleF = self.titleLabel.frame;
    CGRect imageF = self.imageView.frame;
    
    titleF.origin.x = 0;
    self.titleLabel.frame = titleF;
    
    imageF.origin.x = CGRectGetMaxX(titleF) + 10;
    self.imageView.frame = imageF;
}



@end
