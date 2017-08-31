//
//  StyleViewController.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/19.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger ,SelectStyleElement )
{
    SelectFrame=0,   //Frame
    SelectAxis,         //Axis
    SelectNeedle,       //Needle
    SelectRange     //Range
    
};

@interface StyleViewController : UIViewController
{
    UIButton *selectBtn;
}

@property (nonatomic,assign) SelectStyleElement selectStyleElement;



@property (nonatomic,strong) DashboardView *DashViewA;
@property (nonatomic,strong) DashboardViewStyleB *DashViewB;
@property (nonatomic,strong) DashboardViewStyleC *DashViewC;
@property (nonatomic,strong) UIView *DashView;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *NumberLabel;
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,copy) NSString *selectColor;
@property (nonatomic,copy) NSString  *infoLabeltext; //名字

@property (nonatomic,assign) CGFloat StartAngle; //开始角度
@property (nonatomic,assign) CGFloat endAngle;  //结束角度
@property (nonatomic,assign) CGFloat ringWidth;//环形宽度

@property (nonatomic,assign) CGFloat maLength; //长刻度长度
@property (nonatomic,assign) CGFloat maWidth;  //长刻度宽度
@property (nonatomic,copy) NSString  *maColor; //长刻度颜色
@property (nonatomic,assign) CGFloat  miLength; //短刻度长度
@property (nonatomic,assign) CGFloat  miWidth;  //短刻度宽度
@property (nonatomic,copy) NSString  *miColor; //短刻度颜色

@property (nonatomic,copy) NSString *innerColor;  //内径的颜色
@property (nonatomic,copy) NSString *outerColor;  //外径的颜色
@property (nonatomic,copy) NSString *titleColor;  //title颜色
@property (nonatomic,assign) CGFloat titleFontScale;   //字体的倍数
@property (nonatomic,assign) CGFloat titlePosition;  //字体的位置

@property (nonatomic,assign) BOOL ValueVisble; //数值样式能否改变
@property (nonatomic,copy) NSString *ValueColor; //数值字体颜色
@property (nonatomic,assign) CGFloat ValueFontScale; //数值字体颜色倍数
@property (nonatomic,assign) CGFloat ValuePosition;  //数值字体的位置

@property (nonatomic,copy) NSString *UnitColor; //单位字体颜色
@property (nonatomic,assign) CGFloat UnitFontScale; //单位字体颜色倍数
@property (nonatomic,assign) CGFloat UnitVerticalPosition;  //单位字体的横向位置
@property (nonatomic,assign) CGFloat UnitHorizontalPosition;  //单位字体的纵向位置

@property (nonatomic,assign) BOOL LabelVisble; //数字刻度样式能否改变
@property (nonatomic,assign) BOOL LabelRotate; //数字刻度旋转
@property (nonatomic,assign) CGFloat LabelFontScale; //数字刻度字体颜色倍数
@property (nonatomic,assign) CGFloat LabelOffest;  //数字刻度的位置

@property (nonatomic,assign) BOOL PointerVisble; //指针样式能否改变
@property (nonatomic,assign) CGFloat PointerWidth; //指针样式的宽度
@property (nonatomic,assign) CGFloat  PointerLength; //指针样式的长度
@property (nonatomic,copy) NSString *PointerColor;  //指针样式的颜色

@property (nonatomic,assign) CGFloat  KNOBRadius; //圆点样式的半径
@property (nonatomic,copy) NSString *KNOBColor;  //圆点样式的颜色

@property (nonatomic,assign) BOOL Fillenabled; //是否可以填充
@property (nonatomic,assign) CGFloat FillstartAngle; //填充开始角度
@property (nonatomic,assign) CGFloat FillEndAngle; //填充结束角度
//FillIner
//FillOter;
@property (nonatomic,copy) NSString *FillColor; //填充n颜色


@end
