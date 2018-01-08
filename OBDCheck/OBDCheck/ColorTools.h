//
//  ColorTools.h
//  EnterpriseWeb
//
//  Created by 李小斌 on 14-5-28.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

//设置RGB颜色值
#define SETCOLOR(R,G,B,A)	[UIColor colorWithRed:(CGFloat)R/255 green:(CGFloat)G/255 blue:(CGFloat)B/255 alpha:A]

#define KColor  SETCOLOR(234,84,4,1.0)

//#define KColor  [ColorTools colorWithHexString:@"#195a9c"]

// 每个View背景色值
#define KblackgroundColor  [ColorTools colorWithHexString:@"#f0f0f0"]
// 登录框 边框色值
#define KlayerBorder  [ColorTools colorWithHexString:@"#d9d9d9"]
//绿色颜色值
#define GreenColor [ColorTools colorWithHexString:@"#18b15f"]
//粉红颜色值
#define PinkColor  [ColorTools colorWithHexString:@"#e34f4f"]
//蓝色字体颜色值
#define BluewordColor  [ColorTools colorWithHexString:@"#436EEE"]



//主色调 （橙色）
#define VIEWMAINCOLOR_ORANGE ([UIColor colorWithRed:234/255.0 green:84/255.0 blue:4/255.0 alpha:1])

//view背景颜色
#define VIEWBACKGROUNDCOLOR ([UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1])

//view蓝色颜色
#define VIEWBLUECOLOR ([UIColor colorWithRed:24/255.0 green:155/255.0 blue:255/255.0 alpha:1])

//view青色颜色
#define VIEWGREENCOLOR ([UIColor colorWithRed:80/255.0 green:214/255.0 blue:201/255.0 alpha:1])

//主色调 （橙色字体）
#define FONTMAINCOLOR_ORANGE ([UIColor colorWithRed:234/255.0 green:84/255.0 blue:4/255.0 alpha:1])

//黑色字体
#define FONTCOLOR_BLACK ([UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1])

//淡黑色字体
#define FONTCOLOR_LIGHTBLACK ([UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1])

//灰色字体
#define FONTCOLOR_GREY ([UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1])

//淡灰色字体
#define FONTCOLOR_LIGHTGREY ([UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1])

//边框颜色 淡黑色
#define LINECOLOR_LIGHTBLACK ([UIColor colorWithRed:230/255.0 green:233/255.0 blue:238/255.0 alpha:1])

//边框颜色 灰色
#define LINECOLOR_GREY ([UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1])

//button 背景颜色 灰色
#define BUTTONBACKCOLOR_GREY ([UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1])

//button 背景颜色 灰色
#define BUTTONBACKCOLOR_ORANGE ([UIColor colorWithRed:234/255.0 green:84/255.0 blue:4/255.0 alpha:1])

@interface ColorTools : NSObject

/** 颜色转换 IOS中十六进制的颜色转换为UIColor **/
+ (UIColor *) colorWithHexString: (NSString *)color;
+(UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
@end
