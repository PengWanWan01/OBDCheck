//
//  setDistanceUtil.h
//  buyread
//
//  Created by yutaozhao on 2017/7/4.
//  Copyright © 2017年 xiwenjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Start_Y 20.0f           // 第一个按钮的Y坐标

#define Button_Width  100.f
#define Button_Height 100.f

#define twoWidth_Space (MSWidth- 2*Button_Width)/3        // 两个按钮布局2个按钮之间的横间距

#define Height_Space (MSHeight - 199 - 3*Button_Width) /3       // 竖间距

@interface setDistanceUtil : NSObject


+ (CGFloat) setX:(NSInteger)i;
+ (CGFloat) setY:(NSInteger)i;

@end
