//
//  DashboardView.h
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardView : UIView
{
    CGPoint startPoint;
    
}


@property (nonatomic, assign) CGFloat dialLength;

/*
 * 每一个扇形块的刻度个数
 */
@property (nonatomic, assign) NSInteger dialPieceCount;

/*
 * 指针视图
 */
@property (nonatomic, strong) UIImageView *pointerView;

/*
 * 显示信息的label
 */
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic,strong)  UILabel  *numberLabel;
@property (nonatomic,strong)  UILabel  *unitLabel;

@property (nonatomic,assign) NSInteger maxNumber;
@property (nonatomic,assign) NSInteger minNumber;





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
@property (nonatomic,copy) NSString *FillColor; //填充n颜色


- (void)drawCalibration:(CGFloat )TheAngle WithendAngle:(CGFloat)TheendAngle WithRingWidth:(CGFloat)RingWidth MAJORTICKSWidth:(CGFloat)MAWidth MAJORTICKSLength:(CGFloat)MALength MAJORTICKSColor:(NSString *)MAColor MINORTICKSWidth:(CGFloat)MIWidth MINORTICKSLength:(CGFloat)MILength MINORTICKSColor:(NSString *)MIColor LABELSVisible:(BOOL)Visible Rotate:(BOOL)rotate Font:(CGFloat )labelFontScale OffestTickline:(CGFloat)labeloffestTick InnerColor:(NSString *)innerColor TitleColor:(NSString *)titleColor TitleFontScale:(CGFloat)titleFontScale TitlePosition:(CGFloat) titlePosition ValueVisble:(BOOL)valueVisble ValueColor:(NSString *)valueColor ValueFontScale:(CGFloat)valueFontScale ValuePosition:(CGFloat)valuePosition UnitColor:(NSString *)unitColor UnitFontScale:(CGFloat)unitFontScale UnitVerticalPosition:(CGFloat)unitVerticalPosition UnitHorizontalPosition:(CGFloat)unitHorizontalPosition PointerVisble:(BOOL)pointerVisble PointerWidth:(CGFloat)pointerWidth PointerLength:(CGFloat)pointerLength PointerColor:(NSString *)pointerColor KNOBRadius:(CGFloat)kNOBRadius KNOBColor:(NSString *)kNOBColor Fillenabled:(BOOL)fillenabled FillstartAngle:(CGFloat)FillstartAngle FillEndAngle:(CGFloat )fillEndAngle FillColor:(NSString *)fillColor;

- (void)addGradientView:(NSString *)gradientColor GradientViewWidth:(CGFloat )gradientViewWidth;

@end
