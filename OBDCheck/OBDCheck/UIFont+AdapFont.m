//
//  UIFont+AdapFont.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "UIFont+AdapFont.h"

@implementation UIFont (AdapFont)
+ (UIFont *)ToAdapFont:(CGFloat )Number {
//    [self systemFontOfSize:Number*KFontmultiple];
    return [self systemFontOfSize:Number*KFontmultiple];
}

@end
