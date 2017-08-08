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
        RLBtn *btn = [[RLBtn alloc]initWithFrame:CGRectMake(MSWidth- 110, 0, 90, 44)];
        [btn setTitle:@"Rescan" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"矢量智能对象"] forState:UIControlStateNormal];
        btn.alpha = 1;
        [self addSubview:btn];
   
        self.backgroundColor = [ColorTools colorWithHexString:@"#1A1B1E"];
        self.alpha = 0.9;
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
