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
//30db6bc187  App ID
//b4d0a0f7-15a6-468a-9e80-753e6367a249 App Key
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
      [Bugly startWithAppId:@"30db6bc187"];
    NSUserDefaults *TimeOfBootCount = [NSUserDefaults standardUserDefaults];
    if (![TimeOfBootCount valueForKey:@"time"]) {
        [TimeOfBootCount setValue:@"sd" forKey:@"time"];
        DLog(@"第一次启动");
        [self initWithdatabase];
    }else{
//        DLog(@"不是第一次启动");
//        DLog(@"11%ld",(long)[DashboardA bg_version]);

    }
    
    DLog(@"启动成功");

    
    // Override point for customization after application launch.
    ViewController *ROOTVC = [[ViewController alloc]init];
    UINavigationController *NAC = [[UINavigationController alloc]initWithRootViewController:ROOTVC];
    NAC.navigationBar.shadowImage=[ColorTools imageWithColor:[UIColor whiteColor] size:CGSizeMake(MSWidth, 1)];
      
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:NAC];
    [self.window makeKeyAndVisible];
    [UITabBar appearance].backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    [UITabBar appearance].tintColor = [ColorTools colorWithHexString:@"#FE9002"];
//    
    
    return YES;
}

- (void)initWithdatabase{
    [CustomDashboard bg_drop];
    [DashboardA bg_drop];
    [DashboardB bg_drop];
    [DashboardC bg_drop];
    [TripsModel bg_drop];
    [LogsModel bg_drop];
    [[DashboardSetting sharedInstance]initWithdashboardA];
    [[DashboardSetting sharedInstance]initWithdashboardB];
    [[DashboardSetting sharedInstance]initWithdashboardC];
    [[LogsSetting sharedInstance]initWithTrips];

    [[DashboardSetting sharedInstance]initwithCustomDashboard];
    
}


- (void)clearAllUserDefaultsData
{
    [DashboardSetting sharedInstance].dashboardMode = DashboardCustomMode;
    [DashboardSetting sharedInstance].dashboardStyle = DashboardStyleOne;
    [DashboardSetting sharedInstance].numberDecimals = NumberDecimalZero;
    [DashboardSetting sharedInstance].multiplierType = MultiplierType1;
    [DashboardSetting sharedInstance].hudModeType = HUDModeTypeToNormal;
    [DashboardSetting sharedInstance].KPageNumer = 3;
    [DashboardSetting sharedInstance].isAddDashboard = NO;
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
