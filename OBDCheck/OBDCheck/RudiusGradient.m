//
//  RudiusGradient.m
//  NewBoardDash
//
//  Created by yutaozhao on 2018/4/25.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "RudiusGradient.h"

@implementation RudiusGradient
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}
- (void)initWithViewStartColor:(UIColor *)StartColor withendColor:(UIColor *)endColor{
    //创建CGContextRef
    UIGraphicsBeginImageContext(self.bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGMutablePathRef path = CGPathCreateMutable();
    //圆弧
    CGPathAddArc(path, nil,self.frame.size.width/2 , self.frame.size.width/2, self.frame.size.width/2, 0,2 * M_PI, NO);
    //将CGMutablePathRef添加到当前Context内
    CGContextAddPath(context, path);
    //        [[UIColor blueColor] setStroke];
    //        CGContextSetLineWidth(context, 2);
    CGContextDrawPath(context, kCGPathFill);

    //绘制渐变
    [self drawRadialGradient:context path:path startColor:StartColor.CGColor endColor:endColor.CGColor];

    //注意释放CGMutablePathRef
    CGPathRelease(path);

    //从Context中获取图像，并显示在界面上
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [self addSubview:imgView];
    
//    //开始图像绘图
//    UIGraphicsBeginImageContext(self.bounds.size);
//    //获取当前CGContextRef
//    CGContextRef gc = UIGraphicsGetCurrentContext();
//
    //创建用于转移坐标的Transform，这样我们不用按照实际显示做坐标计算
//    CGAffineTransform transform = CGAffineTransformMakeTranslation(50, 50);
//    //创建CGMutablePathRef
//    CGMutablePathRef path = CGPathCreateMutable();
//    //左眼
//    CGPathAddEllipseInRect(path, nil, CGRectMake(0, 0, self.frame.size.width, self.frame.size.width));
////    //右眼
////    CGPathAddEllipseInRect(path, &transform, CGRectMake(80, 0, 20, 20));
////    //笑
////    CGPathMoveToPoint(path, &transform, 100, 50);
////    CGPathAddArc(path, &transform, 50, 50, 50, 0, M_PI, NO);
//    //将CGMutablePathRef添加到当前Context内
//    CGContextAddPath(gc, path);
//    //设置绘图属性
//    [[UIColor blueColor] setStroke];
//    CGContextSetLineWidth(gc, 2);
//    //执行绘画
//    CGContextStrokePath(gc);
//        //绘制渐变
//        [self drawRadialGradient:gc path:path startColor:StartColor.CGColor endColor:endColor.CGColor];
//
//        //注意释放CGMutablePathRef
//        CGPathRelease(path);
//    //从Context中获取图像，并显示在界面上
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    [self addSubview:imgView];
//
}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
