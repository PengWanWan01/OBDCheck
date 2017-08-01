//
//  MyTabBarController.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "MyTabBarController.h"

@interface MyTabBarController ()

@end

@implementation MyTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[UITabBarItem appearance]setTitleTextAttributes:@{NSFontAttributeName:[UIFont   systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}   forState:UIControlStateNormal];
    
    ViewController *vc1 = [[ViewController alloc]init];
//    vc1.title = @"OBD";
    vc1.tabBarItem.title = @"OBD";
    vc1.tabBarItem.image = [UIImage imageNamed:@"设置按钮"];
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];

    SpecialViewController *vc2 = [[SpecialViewController alloc]init];
    vc2.title = @"Special";
    vc2.tabBarItem.image = [UIImage imageNamed:@"设置按钮"];
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    
    PersonalViewController *vc3 = [[PersonalViewController alloc]init];
    vc3.title = @"Personal";
    vc3.tabBarItem.image = [UIImage imageNamed:@"设置按钮"];
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    
    self.viewControllers = @[nav1,nav2,nav3];
   
    
}


@end
