//
//  DashboardA.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/2.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardA : NSObject
@property (nonatomic,copy) NSString  *infoLabeltext; //名字

@property (nonatomic,strong) NSNumber *StartAngle; //开始角度
@property (nonatomic,strong)  NSNumber * endAngle;  //结束角度
@property (nonatomic,strong)  NSNumber * ringWidth;//环形宽度

@property (nonatomic,strong)  NSNumber * maLength; //长刻度长度
@property (nonatomic,strong)  NSNumber * maWidth;  //长刻度宽度
@property (nonatomic,copy) NSString  *maColor; //长刻度颜色
@property (nonatomic,strong)  NSNumber *  miLength; //短刻度长度
@property (nonatomic,strong)  NSNumber *  miWidth;  //短刻度宽度
@property (nonatomic,copy) NSString  *miColor; //短刻度颜色

@property (nonatomic,copy) NSString *innerColor;  //内径的颜色
@property (nonatomic,copy) NSString *outerColor;  //外径的颜色
@property (nonatomic,copy) NSString *titleColor;  //title颜色
@property (nonatomic,strong)  NSNumber * titleFontScale;   //字体的倍数
@property (nonatomic,strong)  NSNumber * titlePosition;  //字体的位置

@property (nonatomic,assign) BOOL ValueVisble; //数值样式能否改变
@property (nonatomic,copy) NSString *ValueColor; //数值字体颜色
@property (nonatomic,strong)  NSNumber * ValueFontScale; //数值字体颜色倍数
@property (nonatomic,strong)  NSNumber * ValuePosition;  //数值字体的位置

@property (nonatomic,copy) NSString *UnitColor; //单位字体颜色
@property (nonatomic,strong)  NSNumber * UnitFontScale; //单位字体颜色倍数
@property (nonatomic,strong)  NSNumber * UnitVerticalPosition;  //单位字体的横向位置
@property (nonatomic,strong)  NSNumber * UnitHorizontalPosition;  //单位字体的纵向位置

@property (nonatomic,assign) BOOL LabelVisble; //数字刻度样式能否改变
@property (nonatomic,assign) BOOL LabelRotate; //数字刻度旋转
@property (nonatomic,strong)  NSNumber * LabelFontScale; //数字刻度字体颜色倍数
@property (nonatomic,strong)  NSNumber * LabelOffest;  //数字刻度的位置

@property (nonatomic,assign) BOOL PointerVisble; //指针样式能否改变
@property (nonatomic,strong) NSNumber * PointerWidth; //指针样式的宽度
@property (nonatomic,strong) NSNumber *  PointerLength; //指针样式的长度
@property (nonatomic,copy) NSString *PointerColor;  //指针样式的颜色

@property (nonatomic,strong) NSNumber *  KNOBRadius; //圆点样式的半径
@property (nonatomic,copy) NSString *KNOBColor;  //圆点样式的颜色

@property (nonatomic,assign) BOOL Fillenabled; //是否可以填充
@property (nonatomic,strong) NSNumber * FillstartAngle; //填充开始角度
@property (nonatomic,strong) NSNumber * FillEndAngle; //填充结束角度
@property (nonatomic,copy) NSString *FillColor; //填充n颜色
@property (nonatomic,strong) NSNumber *orignx; //坐标X轴
@property (nonatomic,strong) NSNumber *origny; //坐标Y轴
@property (nonatomic,strong) NSNumber *orignwidth; //宽
@property (nonatomic,strong) NSNumber *orignheight; //坐标X轴

//@property (nonatomic,assign) BOOL isRemove; //是否可以yi

@end
