//
//  Mode06ViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/14.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "Mode06ViewController.h"

@interface Mode06ViewController ()

@end

@implementation Mode06ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Montiors" andLeftItemImageName:@"back" andRightItemImageName:@"refresh"];
    self.view.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    //    [super prefersStatusBarHidden];
    return NO;
}

//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}
#pragma mark 设置横竖屏布局
- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = CGRectMake(0, 0, MSWidth, MSHeight-TopHigh-64);
}
#pragma mark 竖屏
- (void)setVerticalFrame{
  
}
#pragma mark 横屏
- (void)setHorizontalFrame{
 
}
- (void)initWithUI{
     [self.tableView registerNib:[UINib nibWithNibName:@"MonitorsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MonitorsTableViewCell"];
    
}

- (void)back{
  
}
#pragma mark UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MonitorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MonitorsTableViewCell"];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.f;
}

/**
 刷新
 */
- (void)rightBarButtonClick{
    DLog(@"刷新");
}
@end
