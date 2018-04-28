//
//  DashStyleA.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/25.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashStyleA : UIView
/*
 * 显示信息的label
 */
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic,strong)  UILabel  *numberLabel;
@property (nonatomic,strong)  UILabel  *unitLabel;
- (void)initWithModel:(CustomDashboard *)model;
@end
