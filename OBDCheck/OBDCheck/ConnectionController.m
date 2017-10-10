//
//  ConnectionController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/10/10.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "ConnectionController.h"

@interface ConnectionController ()

@end

@implementation ConnectionController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initNavBarTitle:@"Connection Help" andLeftItemImageName:@"back" andRightItemImageName:@""];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
@end
