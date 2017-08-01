//
//  ViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/7/31.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *statusView;
    UILabel  *statusLabel;
    UIImageView  *statusImageView;

}
@end

@implementation ViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationItem.title = @"Connect";
    self.view.backgroundColor = [UIColor grayColor];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithUI];
}

- (void)initWithUI{
    statusView = [[UIView alloc]initWithFrame:CGRectMake(23, 75, MSWidth - 46, 40)];
    statusView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:statusView];
    //CGRectGetMaxX(statusView.frame)
    statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(statusView.frame) - 63, 0, 45, 40)];
    statusImageView.backgroundColor = [UIColor redColor];
    [statusView addSubview:statusImageView];
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, MSWidth - 86, 40)];
    statusLabel.text = @"Connect to the device successfully";
    statusLabel.font = [UIFont systemFontOfSize:16.f];
    [statusView addSubview:statusLabel];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(statusView.frame) + 20, MSWidth, MSHeight - 49 - 150)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
