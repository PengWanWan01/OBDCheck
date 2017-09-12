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
    //取到tabbar下面的线条
    CGRect rect = CGRectMake(0, 0, MSWidth, MSHeight);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];

            ViewController *vc1 = [[ViewController alloc]init];
            vc1.tabBarItem.selectedImage=[[UIImage imageNamed:@"troubleCode_highLight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc1.tabBarItem.image= [[UIImage imageNamed:@"troubleCode_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc1.tabBarItem.title = @"trouble Codes";
   

            UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
            
            FreezeViewController *vc2 = [[FreezeViewController alloc]init];
            vc2.tabBarItem.selectedImage=[[UIImage imageNamed:@"Freeze_highlight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc2.tabBarItem.image= [[UIImage imageNamed:@"freeze_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc2.tabBarItem.title = @"Freeze Frame";
            UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
            
            ReadinessViewController *vc3 = [[ReadinessViewController alloc]init];
            vc3.tabBarItem.selectedImage=[[UIImage imageNamed:@"readiness_highLight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc3.tabBarItem.image= [[UIImage imageNamed:@"readiness_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc3.tabBarItem.title  = @"Readiness Test";
            UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:vc3];
            
            ReportViewController *vc4 = [[ReportViewController alloc]init];
            vc4.tabBarItem.selectedImage=[[UIImage imageNamed:@"report_highLight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc4.tabBarItem.image= [[UIImage imageNamed:@"report_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            vc4.tabBarItem.title  = @"Report";
            UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:vc4];
            
            self.viewControllers = @[nav1,nav2,nav3,nav4];
  
    
  }


@end
