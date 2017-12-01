//
//  TheBasicViewController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/12/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "TheBasicViewController.h"

@interface TheBasicViewController ()

@end

@implementation TheBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
