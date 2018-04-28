//
//  RudiusGradient.h
//  NewBoardDash
//
//  Created by yutaozhao on 2018/4/25.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RudiusGradient : UIView

/**
 自定义径向渐变的圆形

 @param StartColor 渐变开始颜色
 @param endColor 渐变结束颜色
 */
- (void)initWithViewStartColor:(UIColor *)StartColor withendColor:(UIColor *)endColor;
@end
