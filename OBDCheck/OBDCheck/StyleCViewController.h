//
//  StyleCViewController.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/26.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleCViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *NumberLabel;
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,copy) NSString *selectColor;
@property (nonatomic,strong) UISlider *slider;


@property (nonatomic,copy) NSString *innerColor;
@property (nonatomic,copy) NSString *outerColor;
@property (nonatomic,copy) NSString *GradientColor;

@property (nonatomic,copy) NSString *titleColor;
@property (nonatomic,assign) CGFloat titleFontScale;
@property (nonatomic,assign) CGFloat titlePositon;

@property (nonatomic,assign) BOOL ValueVisible;
@property (nonatomic,copy ) NSString *ValueColor;
@property (nonatomic,assign) CGFloat ValueFontScale;
@property (nonatomic,assign) CGFloat ValuePositon;

@property (nonatomic,copy ) NSString *UnitColor;
@property (nonatomic,assign) CGFloat UnitFontScale;
@property (nonatomic,assign) CGFloat UnitPositon;

@property (nonatomic,copy) NSString *FrameColor;
@property (nonatomic,assign) CGFloat FrameScale;
@end
