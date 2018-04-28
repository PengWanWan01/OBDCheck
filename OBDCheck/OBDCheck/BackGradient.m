//
//  BackGradient.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/25.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "BackGradient.h"

@implementation BackGradient

- (void)initWithUIWidth:(CGFloat)Width withStartAngle:(CGFloat )StartAngle withendAngle:(CGFloat )endAngle  withstartPoint:(CGPoint )startPoint withendPoint:(CGPoint )endPoint withStartColor:(UIColor *)StartColor withendColor:(UIColor *)endColor {
    DLog(@"lailailai");
//    self.backgroundColor = [UIColor orangeColor];
    if (self.ShaowBool) { //如何为需要添加阴影部分,则设置这个属性为YES
        CAShapeLayer *layer = [CAShapeLayer new];
        layer.lineWidth = Width;
        //圆环的颜色
        layer.strokeColor = [UIColor whiteColor].CGColor;
        //发光效果
        layer.shadowRadius = 3;
        layer.shadowColor = [UIColor whiteColor].CGColor;
        layer.shadowOffset = CGSizeMake(0, 0);
        layer.shadowOpacity = 1.0;
        //背景填充色
        layer.fillColor = [UIColor clearColor].CGColor;
        //设置半径为10
        CGFloat radius = self.frame.size.width/2.0f - (Width+1)/2;
        //按照顺时针方向
        BOOL clockWise = true;
        //初始化一个路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:radius startAngle:(M_PI) endAngle:0 clockwise:clockWise];
        layer.path = [path CGPath];
        [self.layer addSublayer:layer];

    }
    CAShapeLayer *layer = [CAShapeLayer new];
    layer.lineWidth = Width;
    //圆环的颜色
    layer.strokeColor = [UIColor redColor].CGColor;
    //背景填充色
    layer.fillColor = [UIColor clearColor].CGColor;
   
    
    //设置半径为10
    CGFloat radius = self.frame.size.width/2.0f - Width/2;
    //按照顺时针方向
    BOOL clockWise = true;
    //初始化一个路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2) radius:radius startAngle:(StartAngle) endAngle:endAngle clockwise:clockWise];
    layer.path = [path CGPath];
    [self.layer addSublayer:layer];
    
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);  // 设置显示的frame
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[StartColor CGColor],(id)[endColor CGColor], nil]];
    gradientLayer.startPoint = startPoint;
    gradientLayer.endPoint = endPoint;
    [self.layer addSublayer:gradientLayer];
    [gradientLayer setMask:layer];
}

@end
