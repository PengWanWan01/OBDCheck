//
//  DashboardB.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/6.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashboardB : NSObject
@property (nonatomic,copy) NSString *backColor;
@property (nonatomic,strong) NSNumber* GradientRadius;

@property (nonatomic,copy) NSString *titleColor;
@property (nonatomic,strong) NSNumber* titleFontScale;
@property (nonatomic,strong) NSNumber* titlePositon;

@property (nonatomic,assign) BOOL ValueVisible;
@property (nonatomic,copy ) NSString *ValueColor;
@property (nonatomic,strong) NSNumber* ValueFontScale;
@property (nonatomic,strong) NSNumber* ValuePositon;

@property (nonatomic,copy ) NSString *UnitColor;
@property (nonatomic,strong) NSNumber* UnitFontScale;
@property (nonatomic,strong) NSNumber* UnitPositon;

@property (nonatomic,copy) NSString *pointerColor;
@property (nonatomic,strong) NSNumber* Pointerwidth;
@property (nonatomic,assign) BOOL FillEnable;
@property (nonatomic,copy ) NSString *FillColor;
@property (nonatomic,strong) NSNumber *orignx; //坐标X轴
@property (nonatomic,strong) NSNumber *origny; //坐标Y轴
@property (nonatomic,strong) NSNumber *orignwidth; //宽
@property (nonatomic,strong) NSNumber *orignheight; //坐标X轴
@property (nonatomic,copy) NSString *minNumber;  //最小值
@property (nonatomic,copy) NSString *maxNumber;  //最大值
@end
