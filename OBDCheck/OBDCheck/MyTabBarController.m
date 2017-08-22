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
    
    //obd_normal",@"special_normal",@"personal_normal
    ViewController *vc1 = [[ViewController alloc]init];
    vc1.tabBarItem.selectedImage=[[UIImage imageNamed:@"obd_highlight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem.image= [[UIImage imageNamed:@"obd_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 3, -6, -3);
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    
    SpecialViewController *vc2 = [[SpecialViewController alloc]init];
    vc2.tabBarItem.selectedImage=[[UIImage imageNamed:@"special_highlight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem.image= [[UIImage imageNamed:@"special_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 3, -6, -3);

    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    
    PersonalViewController *vc3 = [[PersonalViewController alloc]init];
    vc3.tabBarItem.selectedImage=[[UIImage imageNamed:@"personal_highlight"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc3.tabBarItem.image= [[UIImage imageNamed:@"personal_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 3, -6, -3);
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    
    self.viewControllers = @[nav1,nav2,nav3];
    
  }


@end
