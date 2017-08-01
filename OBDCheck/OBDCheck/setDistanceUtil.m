//
//  setDistanceUtil.m
//  buyread
//
//  Created by yutaozhao on 2017/7/4.
//  Copyright © 2017年 xiwenjin. All rights reserved.
//

#import "setDistanceUtil.h"


@implementation setDistanceUtil

+(CGFloat)setX:(NSInteger)i{
    
    CGFloat resultX;
   NSInteger index = i % 2;
    CGFloat Space = (CGFloat)(twoWidth_Space) ;
        resultX = index * (Button_Width + Space) + Space;
   
    return resultX;

}
+ (CGFloat)setY :(NSInteger)i{
   
    CGFloat resultY = 0.0;
   NSInteger page = i / 2;
   resultY =  page  * (Button_Height + Height_Space)+Start_Y;
        
      return resultY;
}


@end
