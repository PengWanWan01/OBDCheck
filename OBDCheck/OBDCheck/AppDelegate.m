//
//  AppDelegate.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/7/31.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    if (![TimeOfBootCount valueForKey:@"time"]) {
        [TimeOfBootCount setValue:@"sd" forKey:@"time"];
        NSLog(@"第一次启动");
        [DashboardA bg_drop];
        [DashboardB bg_drop];
        [DashboardC bg_drop];

        [[DashboardSetting sharedInstance] initWithdashboardA];
        [[DashboardSetting sharedInstance] initWithdashboardB];
        [[DashboardSetting sharedInstance] initWithdashboardC];

        
    }else{
        NSLog(@"不是第一次启动");
        NSLog(@"11%ld",(long)[DashboardA bg_version]);

    }
    
    NSLog(@"启动成功");

    
    // Override point for customization after application launch.
    MyTabBarController *tabbar = [[MyTabBarController alloc]init];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:tabbar];
    [self.window makeKeyAndVisible];
    [UITabBar appearance].backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    [UITabBar appearance].tintColor = [ColorTools colorWithHexString:@"#FE9002"];
//    
    
    return YES;
}


- (void)clearAllUserDefaultsData
{
    [DashboardSetting sharedInstance].dashboardMode = DashboardCustomMode;
    [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleOne;
    [DashboardSetting sharedInstance].numberDecimals = NumberDecimalZero;
    [DashboardSetting sharedInstance].multiplierType = MultiplierType1;
    [DashboardSetting sharedInstance].hudModeType = HUDModeTypeToNormal;
    [DashboardSetting sharedInstance].KPageNumer = 3;
    [DashboardSetting sharedInstance].AddDashboardNumber = 0;
    [DashboardSetting sharedInstance].isDashboardFont = NO;
    [DashboardSetting sharedInstance].isDashboardMove = NO;
    [DashboardSetting sharedInstance].isDashboardRemove = NO;
    [DashboardSetting sharedInstance].RemoveDashboardNumber = 0;
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
