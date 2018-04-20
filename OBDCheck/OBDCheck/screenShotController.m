//
//  screenShotController.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/20.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "screenShotController.h"

@interface screenShotController ()

@end

@implementation screenShotController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNavBarTitle:@"截图内容" andLeftItemImageName:@"back" andRightItemName:@""];
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
