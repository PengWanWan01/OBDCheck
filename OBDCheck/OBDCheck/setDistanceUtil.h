//
//  setDistanceUtil.h
//  buyread
//
//  Created by yutaozhao on 2017/7/4.
//  Copyright © 2017年 xiwenjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Start_Y 20*MSHeight/667           // 第一个按钮的Y坐标

#define Button_Width 100*MSWidth/375
#define Button_Height 100*MSWidth/375 + 30

#define twoWidth_Space MSWidth-2*Button_Width - 126*MSWidth/375       // 两个按钮布局2个按钮之间的横间距

#define Height_Space    IS_IPHONE_5?20:33   // 竖间距

@interface setDistanceUtil : NSObject


+ (CGFloat) setX:(NSInteger)i;
+ (CGFloat) setY:(NSInteger)i;

@end
