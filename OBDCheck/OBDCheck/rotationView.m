//
//  rotationView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/30.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "rotationView.h"

@implementation rotationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rotationImage.contentMode = UIViewContentModeScaleAspectFill;
        self.rotationImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth,ViewHeight)];
        [self rotate360WithDuration:0.5 repeatCount:100];
        [self addSubview:self.rotationImage];
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        self.numberLabel.textColor = [ColorTools colorWithHexString:@"#C8C6C6"];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.text = @"50%";
        self.numberLabel.font = [UIFont ToAdapFont:10.f];
        [self addSubview:self.numberLabel];
    }
    return self;
}
- (void)rotate360WithDuration:(CGFloat)aDuration repeatCount:(CGFloat)aRepeatCount  {
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
    theAnimation.values = [NSArray arrayWithObjects:
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,0,1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0,0,1)],
                           [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0,0,1)],
                           nil];
    theAnimation.cumulative = YES;
    theAnimation.duration = aDuration;
    theAnimation.repeatCount = aRepeatCount;
    theAnimation.removedOnCompletion = YES;
    theAnimation.timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                        nil
                                        ];
    
    [self.rotationImage.layer addAnimation:theAnimation forKey:@"transform"];
}


@end
