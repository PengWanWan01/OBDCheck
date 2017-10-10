//
//  gradientView.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "gradientView.h"

@implementation gradientView
- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = ViewWidth/2;
    self.layer.masksToBounds = YES;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //1.Create CGColorSpaceRef
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    //2.Create CGGradientRef
    //颜色分配:四个一组代表一种颜色(r,g,b,a)
    CGFloat components[8] = {[[self getRGBWithColor:self.startGradientColor][0] floatValue], [[self getRGBWithColor:self.startGradientColor][1] floatValue], [[self getRGBWithColor:self.startGradientColor][2] floatValue], 1.0,[[self getRGBWithColor:self.endGradientColor][0] floatValue], [[self getRGBWithColor:self.endGradientColor][1] floatValue] ,[[self getRGBWithColor:self.endGradientColor][2] floatValue], 1.0};
    //位置:每种颜色对应中心点位置,取0-1之间的float,默认起始点为(0,0)
    CGFloat locations[2] = {0, 1};
    //点数量:count为locations数量,size_t类型
    size_t count = 2;
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    
    //3.DrawRadialGradient
    /**渐变点:
     起始点
     结束点
     起始半径
     结束半径
     */
    CGPoint startCenter = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGPoint endCenter = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat startRadius = 0;    
    CGContextDrawRadialGradient(context, gradient, startCenter, startRadius, endCenter, self.gradientRadius, kCGGradientDrawsAfterEndLocation);
    
    //4.Release
    CGColorSpaceRelease(colorSpace);
    colorSpace = NULL;
    CGGradientRelease(gradient);
    gradient = NULL;
    
    
}
- (NSArray *)getRGBWithColor:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    return @[@(red), @(green), @(blue), @(alpha)];
}


@end
