//
//  DashboardViewA.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/23.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardViewA : UIView

@property (nonatomic,strong)  DashboardView *dashView;
@property (nonatomic,strong)  UILabel  *numberLabel;
@property (nonatomic,strong)  UILabel  *infoLabel;
@property (nonatomic,assign) CGFloat StartAngle; //开始角度
@property (nonatomic,assign) CGFloat endAngle;  //结束角度
@property (nonatomic) UIColor *innerColor;  //内径的颜色
@property (nonatomic) UIColor *outerColor;  //外径的颜色
@property (nonatomic,assign) CGFloat LongscaleWidth; //长刻度宽度
@property (nonatomic,assign) CGFloat ShortscaleWidth; //短刻度宽度
@end
