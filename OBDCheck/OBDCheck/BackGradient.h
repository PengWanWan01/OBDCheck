//
//  BackGradient.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/25.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackGradient : UIView
@property (nonatomic,assign)BOOL ShaowBool;

/**
 自定义圆形的线性渐变,ShaowBool可以设置是否带描边的发光效果

 @param Width 渐变的宽度
 @param StartAngle 渐变的开始角度
 @param endAngle 渐变的结束角度
 @param startPoint 渐变颜色的开始点
 @param endPoint  渐变颜色的结束点
 @param StartColor 渐变开始颜色
 @param endColor 渐变介绍颜色
 */
- (void)initWithUIWidth:(CGFloat)Width withStartAngle:(CGFloat )StartAngle withendAngle:(CGFloat )endAngle  withstartPoint:(CGPoint )startPoint withendPoint:(CGPoint )endPoint withStartColor:(UIColor *)StartColor withendColor:(UIColor *)endColor ;

@end
