//
//  CustomDashboard.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/7.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "JKDBModel.h"



@interface CustomDashboard : JKDBModel
@property (nonatomic,assign) NSInteger  dashboardType ;

@property (nonatomic,copy) NSString *DashboardPID;  //PID的值
@property (nonatomic,copy) NSString *DashboardminNumber;  //最小值
@property (nonatomic,copy) NSString *DashboardmaxNumber;  //最大值

@property (nonatomic,copy) NSString *DashboardAStartAngle; //开始角度
@property (nonatomic,copy)  NSString *DashboardAendAngle;  //结束角度
@property (nonatomic,copy)  NSString * DashboardAringWidth;//环形宽度

@property (nonatomic,copy)  NSString * DashboardAmaLength; //长刻度长度
@property (nonatomic,copy)  NSString * DashboardAmaWidth;  //长刻度宽度
@property (nonatomic,copy) NSString  *DashboardAmaColor; //长刻度颜色
@property (nonatomic,copy)  NSString *  DashboardAmiLength; //短刻度长度
@property (nonatomic,copy)  NSString *  DashboardAmiWidth;  //短刻度宽度
@property (nonatomic,copy) NSString  *DashboardAmiColor; //短刻度颜色

@property (nonatomic,copy) NSString *DashboardAinnerColor;  //内径的颜色
@property (nonatomic,copy) NSString *DashboardAouterColor;  //外径的颜色
@property (nonatomic,copy) NSString *DashboardAtitleColor;  //title颜色
@property (nonatomic,copy)  NSString * DashboardAtitleFontScale;   //字体的倍数
@property (nonatomic,copy)  NSString * DashboardAtitlePosition;  //字体的位置

@property (nonatomic,assign) BOOL DashboardAValueVisble; //数值样式能否改变
@property (nonatomic,copy) NSString *DashboardAValueColor; //数值字体颜色
@property (nonatomic,copy)  NSString * DashboardAValueFontScale; //数值字体颜色倍数
@property (nonatomic,copy)  NSString * DashboardAValuePosition;  //数值字体的位置

@property (nonatomic,copy) NSString *DashboardAUnitColor; //单位字体颜色
@property (nonatomic,copy)  NSString * DashboardAUnitFontScale; //单位字体颜色倍数
@property (nonatomic,copy)  NSString * DashboardAUnitVerticalPosition;  //单位字体的横向位置
@property (nonatomic,copy)  NSString * DashboardAUnitHorizontalPosition;  //单位字体的纵向位置

@property (nonatomic,assign) BOOL DashboardALabelVisble; //数字刻度样式能否改变
@property (nonatomic,assign) BOOL DashboardALabelRotate; //数字刻度旋转
@property (nonatomic,copy)  NSString * DashboardALabelFontScale; //数字刻度字体颜色倍数
@property (nonatomic,copy)  NSString * DashboardALabelOffest;  //数字刻度的位置

@property (nonatomic,assign) BOOL DashboardAPointerVisble; //指针样式能否改变
@property (nonatomic,copy) NSString * DashboardAPointerWidth; //指针样式的宽度
@property (nonatomic,copy) NSString *  DashboardAPointerLength; //指针样式的长度
@property (nonatomic,copy) NSString *DashboardAPointerColor;  //指针样式的颜色

@property (nonatomic,copy) NSString *  DashboardAKNOBRadius; //圆点样式的半径
@property (nonatomic,copy) NSString *DashboardAKNOBColor;  //圆点样式的颜色

@property (nonatomic,assign) BOOL DashboardAFillenabled; //是否可以填充
@property (nonatomic,copy) NSString * DashboardAFillstartAngle; //填充开始角度
@property (nonatomic,copy) NSString * DashboardAFillEndAngle; //填充结束角度
@property (nonatomic,copy) NSString *DashboardAFillColor; //填充n颜色
@property (nonatomic,copy) NSString *DashboardAorignx; //坐标X轴
@property (nonatomic,copy) NSString *DashboardAorigny; //坐标Y轴
@property (nonatomic,copy) NSString *DashboardAorignwidth; //宽
@property (nonatomic,copy) NSString *DashboardAorignheight; //坐标X轴



@property (nonatomic,copy) NSString *DashboardBbackColor;
@property (nonatomic,copy) NSString* DashboardBGradientRadius;

@property (nonatomic,copy) NSString *DashboardBtitleColor;
@property (nonatomic,copy) NSString* DashboardBtitleFontScale;
@property (nonatomic,copy) NSString* DashboardBtitlePositon;

@property (nonatomic,assign) BOOL DashboardBValueVisible;
@property (nonatomic,copy ) NSString *DashboardBValueColor;
@property (nonatomic,copy) NSString* DashboardBValueFontScale;
@property (nonatomic,copy) NSString* DashboardBValuePositon;

@property (nonatomic,copy ) NSString *DashboardBUnitColor;
@property (nonatomic,copy) NSString* DashboardBUnitFontScale;
@property (nonatomic,copy) NSString* DashboardBUnitPositon;

@property (nonatomic,copy) NSString *DashboardBpointerColor;
@property (nonatomic,copy) NSString* DashboardBPointerwidth;
@property (nonatomic,assign) BOOL DashboardBFillEnable;
@property (nonatomic,copy ) NSString *DashboardBFillColor;
@property (nonatomic,copy) NSString *DashboardBorignx; //坐标X轴
@property (nonatomic,copy) NSString *DashboardBorigny; //坐标Y轴
@property (nonatomic,copy) NSString *DashboardBorignwidth; //宽
@property (nonatomic,copy) NSString *DashboardBorignheight; //坐标X轴





@property (nonatomic,copy) NSString *DashboardCinnerColor;
@property (nonatomic,copy) NSString *DashboardCouterColor;

@property (nonatomic,copy) NSString * DashboardCGradientradius;

@property (nonatomic,copy) NSString *DashboardCtitleColor;
@property (nonatomic,copy) NSString * DashboardCtitleFontScale;
@property (nonatomic,copy) NSString * DashboardCtitlePositon;

@property (nonatomic,assign) BOOL DashboardCValueVisible;
@property (nonatomic,copy ) NSString *DashboardCValueColor;
@property (nonatomic,copy) NSString * DashboardCValueFontScale;
@property (nonatomic,copy) NSString * DashboardCValuePositon;

@property (nonatomic,copy ) NSString *DashboardCUnitColor;
@property (nonatomic,copy) NSString * DashboardCUnitFontScale;
@property (nonatomic,copy) NSString * DashboardCUnitPositon;

@property (nonatomic,copy) NSString *DashboardCFrameColor;
@property (nonatomic,copy) NSString *DashboardCorignx; //坐标X轴
@property (nonatomic,copy) NSString *DashboardCorigny; //坐标Y轴
@property (nonatomic,copy) NSString *DashboardCorignwidth; //宽
@property (nonatomic,copy) NSString *DashboardCorignheight; //坐标X轴


@end
