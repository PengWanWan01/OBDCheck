//
//  setDistanceUtil.h
//  buyread
//
//  Created by yutaozhao on 2017/7/4.
//  Copyright © 2017年 xiwenjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Start_Y 20*SCREEN_MAX/667           // 第一个按钮的Y坐标

#define Button_Width 100*SCREEN_MIN/375
#define Button_Height  IS_IPHONE_4_OR_LESS?(100*SCREEN_MIN/375 + 20*SCREEN_MAX/667):(100*SCREEN_MIN/375 + 30*SCREEN_MAX/667)

#define twoWidth_Space SCREEN_MIN-2*Button_Width - 126*SCREEN_MIN/375       // 两个按钮布局2个按钮之间的横间距

#define Height_Space    IS_IPHONE_5?20:33   // 竖间距

@interface setDistanceUtil : NSObject


+ (CGFloat) setX:(NSInteger)i;
+ (CGFloat) setY:(NSInteger)i;

@end
