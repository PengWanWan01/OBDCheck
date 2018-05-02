//
//  HUDView.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/18.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HUDView : UIView
@property (nonatomic,strong) UILabel *PIDLabel;
@property (nonatomic,strong) UILabel *NumberLabel;
@property (nonatomic,strong) UILabel *UnitLabel;
@property (nonatomic,strong) UIView *RightLine;
@property (nonatomic,strong) UIView  *buttomLine;
@end
