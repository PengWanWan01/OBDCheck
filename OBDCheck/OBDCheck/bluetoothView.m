//
//  bluetoothView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "bluetoothView.h"

@implementation bluetoothView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, MSWidth, 44)];
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitle:@"Rescan" forState:UIControlStateNormal];
        btn.alpha = 1;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self addSubview:btn];
        
        
        self.backgroundColor = [ColorTools colorWithHexString:@"#888888"];
        self.alpha = 0.5;
    }
    return self;
}
- (void)show{
    
    UIWindow *win = [[UIApplication sharedApplication] keyWindow];
    //        UIView *topView = [win.subviews firstObject];
    //        [topView addSubview:self];
    [win addSubview:self];
    
    [win bringSubviewToFront:self];
    
    
    [UIView animateWithDuration:0.1 animations:^{
        
        [self layoutIfNeeded];
    }];
    
}
- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
@end
