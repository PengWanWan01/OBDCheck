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

@interface StyleViewController : TheBasicViewController
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


@end
