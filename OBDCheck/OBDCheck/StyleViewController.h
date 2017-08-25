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

@property (nonatomic,assign) CGFloat theStartAngle; //开始角度
@property (nonatomic,assign) CGFloat endAngle;  //结束角度
@property (nonatomic,assign) CGFloat ringWidth;//环形宽度

@property (nonatomic,assign) CGFloat maLength; //长刻度长度
@property (nonatomic,assign) CGFloat maWidth;  //长刻度宽度
@property (nonatomic) UIColor * maColor; //长刻度颜色
@property (nonatomic,assign) CGFloat  miLength; //短刻度长度
@property (nonatomic,assign) CGFloat  miWidth;  //短刻度宽度
@property (nonatomic) UIColor  *miColor; //短刻度颜色
@property (nonatomic) UIColor  *outColor; //完全颜色

@end
