//
//  StyleCViewController.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/26.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StyleCViewController : TheBasicViewController
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UILabel *NumberLabel;
@property (nonatomic,strong) NSMutableArray *datasource;
@property (nonatomic,copy) NSString *selectColor;
@property (nonatomic,strong) UISlider *slider;



@end
