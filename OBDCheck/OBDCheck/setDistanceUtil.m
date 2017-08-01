//
//  setDistanceUtil.m
//  buyread
//
//  Created by yutaozhao on 2017/7/4.
//  Copyright © 2017年 xiwenjin. All rights reserved.
//

#import "setDistanceUtil.h"


@implementation setDistanceUtil
+(CGFloat)setX:(NSString *)type :(NSInteger)i{
    
    CGFloat resultX;
    
    if ([type isEqualToString:@"01"]) {
        resultX =    MSWidth/2 - 38;
    }else if ([type isEqualToString:@"02"] || [type isEqualToString:@"04"]){
        NSInteger index = i % 2;
       
        
    CGFloat Space = (CGFloat)(twoWidth_Space) ;
        resultX = index * (Button_Width + Space) + MSWidth/6;
    }
    else {
        NSInteger index = i % 3;
        CGFloat Space = (CGFloat)(Width_Space)/2;
        resultX = index * (Button_Width + Space) + 20;
        
    }
    return resultX;

}
+ (CGFloat)setY:(NSString *)type :(NSInteger)i{
   
    CGFloat resultY = 0.0;
    if ([type isEqualToString:@"01"]) {
        resultY =   0;
    }else if ([type isEqualToString:@"02"] || [type isEqualToString:@"04"]){
        NSInteger page = i / 2;
        resultY =  page  * (Button_Height + Height_Space)+Start_Y;
        
        
    }
    else {
        NSInteger page = i / 3;
//        Height_Space
        //Button_Height
        resultY =  page  * (Button_Height + Height_Space)+Start_Y;
        
        ;
        
    }
    return resultY;
}
+ (CGFloat) titleLabelsetX:(NSString *) type:(NSInteger)i{
    CGFloat resultX;
    
    if ([type isEqualToString:@"01"]) {
        resultX =    MSWidth/2 - titleButton_Width/2 ;
    }else if ([type isEqualToString:@"02"] || [type isEqualToString:@"04"]){
               NSInteger index = i % 2;
        
        
        CGFloat Space = (CGFloat)(titleWidth_Space) ;
        resultX = index * (titleButton_Width + Space) + MSWidth/6;
    }
    else {
        NSInteger index = i % 3;
        CGFloat Space = (CGFloat)(titleWidth_Space)/2;
        resultX = index * (titleButton_Width + Space) + 20;
        
    }
    return resultX;
}
+ (CGFloat) titleLabelsetY:(NSString *) type:(NSInteger)i withheightSpace:(CGFloat)Space{
    CGFloat resultY = 0.0;
    if ([type isEqualToString:@"01"]) {
        resultY =   10;
    }else if ([type isEqualToString:@"02"] || [type isEqualToString:@"04"]){
        NSInteger page = i / 2;
        
        resultY =  page  * (titleButton_Height + Space)+10;
        
        
    }
    else {
        NSInteger page = i / 3;
        //        Height_Space
        //Button_Height
        resultY =  page  * (titleButton_Height + Space)+10;
        
        ;
        
    }
    return resultY;
}

@end
