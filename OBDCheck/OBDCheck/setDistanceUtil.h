//
//  setDistanceUtil.h
//  buyread
//
//  Created by yutaozhao on 2017/7/4.
//  Copyright © 2017年 xiwenjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#define Start_Y 0.0f           // 第一个按钮的Y坐标
#define Button_Height 80.0f    // 高
#define Button_Width 80.0f      // 宽
#define Width_Space (MSWidth - 3*Button_Width - 40)        //三个按钮布局 2个按钮之间的横间距
#define twoWidth_Space ( MSWidth- 2*Button_Width -  MSWidth/3)        // 两个按钮布局2个按钮之间的横间距

#define Height_Space 20.0f      // 竖间距
#define titleWidth_Space (MSWidth - 3*titleButton_Width - 40)        //三个按钮布局 2个按钮之间的横间距
#define titletWidth_Space (MSWidth - 2*titleButton_Width -  SCREEN_WIDTH/3)        // 两个按钮布局2个按钮之间的横间距
#define titleButton_Width MSWidth/4
#define titleButton_Height 30

#define titleHeight_Space 10.0f      // 文字按钮竖间距

@interface setDistanceUtil : NSObject

+ (CGFloat) setX:(NSString *) type:(NSInteger)i;
+ (CGFloat) setY:(NSString *) type:(NSInteger)i;
+ (CGFloat) titleLabelsetX:(NSString *) type:(NSInteger)i;  //等比例布局  设置X轴文字按钮的方法
+ (CGFloat) titleLabelsetY:(NSString *) type:(NSInteger)i withheightSpace:(CGFloat)Space;
@end
