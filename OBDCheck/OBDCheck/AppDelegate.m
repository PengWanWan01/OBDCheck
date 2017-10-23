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
        [self initWithdatabase];
    }else{
//        NSLog(@"不是第一次启动");
//        NSLog(@"11%ld",(long)[DashboardA bg_version]);

    }
    
    NSLog(@"启动成功");

    
    // Override point for customization after application launch.
    ViewController *ROOTVC = [[ViewController alloc]init];
    UINavigationController *NAC = [[UINavigationController alloc]initWithRootViewController:ROOTVC];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:NAC];
    [self.window makeKeyAndVisible];
    [UITabBar appearance].backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    [UITabBar appearance].tintColor = [ColorTools colorWithHexString:@"#FE9002"];
//    
    
    return YES;
}
- (void)initWithdatabase{
    [self initwithCustomDashboard];
    
}
- (void)initwithCustomDashboard{
    
    for (int i = 0; i< 9; i++) {
        if (i<6) {
            [self CustomDashboardType:1 withTag:i];
        }else if (i>=6 && i < 8){
            
            [self CustomDashboardType:2 withTag:i] ;
        }else{
            [self CustomDashboardType:3 withTag:i];
        }
    }
    
}
- (void)CustomDashboardType:(NSInteger)type withTag:(NSInteger)i{
    NSLog(@"12121212");
   
    DashboardA *dashA = [DashboardA new];
    [self initADDdashboardA:dashA withTag:i ];
  
    
    DashboardB *dashB = [DashboardB new];
    [self initADDdashboardB:dashB withTag:i];
//     model.dashboardB = dashB;
    
    DashboardC *dashC = [DashboardC new];
    [self initADDdashboardC:dashC withTag:i];
//    model.dashboardC = dashC;
    
//    switch (type) {
//        case 1:
//        {
//            model.dashboardType = 1;
//            [model bg_saveOrUpdate];
//        }
//            break;
//        case 2:
//        {
//            model.dashboardType = 2;
//            [model bg_saveOrUpdate];
//        }
//            break;
//        case 3:
//        {
//            model.dashboardType = 3;
//            [model bg_saveOrUpdate];
//        }
//            break;
//        default:
//            break;
//    }
//
}
- (void)initADDdashboardA:(DashboardA *)dash withTag:(NSInteger)i {
     CustomDashboard *customDash = [CustomDashboard new];
    DashboardA *model = [DashboardA new];
    model.titleColor = @"FE9002";
    model.titleFontScale = [NSNumber numberWithFloat:1];
    model.titlePosition = [NSNumber numberWithFloat:1];
    
    model.ValueVisble = YES;
    model.ValueFontScale = [NSNumber numberWithFloat:1];
    model.ValuePosition =[NSNumber numberWithFloat:1];
    model.ValueColor = @"FE9002";
    
    model.LabelVisble = YES;
    model.LabelRotate = YES;
    model.LabelOffest = [NSNumber numberWithFloat:1];
    model.LabelFontScale = [NSNumber numberWithFloat:1];
    
    model.PointerVisble = YES;
    model.PointerWidth = [NSNumber numberWithFloat:10];
    model.PointerLength = [NSNumber numberWithFloat:(160/2) - 15 - 14];
    model.PointerColor = @"FE9002";
    
    model.KNOBRadius = [NSNumber numberWithFloat:10.f];
    model.KNOBColor = @"FFFFFF";
    
    model.Fillenabled = YES;
    model.FillstartAngle = [NSNumber numberWithFloat:0];
    model.FillEndAngle = [NSNumber numberWithFloat:0];
    model.FillColor = @"FE9002";
    
    model.UnitColor = @"FE9002";
    model.UnitFontScale = [NSNumber numberWithFloat:1];
    model.UnitVerticalPosition = [NSNumber numberWithFloat:1];
    model.UnitHorizontalPosition = [NSNumber numberWithFloat:1];
    
    model.StartAngle = [NSNumber numberWithFloat:0.f];
    model.endAngle = [NSNumber numberWithFloat:2*M_PI];
    model.ringWidth = [NSNumber numberWithFloat:10.f];
    model.maLength = [NSNumber numberWithFloat:15.f];
    model.miLength = [NSNumber numberWithFloat:5];
    model.miWidth = [NSNumber numberWithFloat:10.f];
    model.maWidth = [NSNumber numberWithFloat:10.f];
    model.maColor = @"FFFFFF";
    model.miColor = @"FFFFFF";
    model.innerColor = @"18191C";
    model.outerColor = @"18191C";
    NSInteger index = i % 2;
    NSInteger page = i / 2;
    CGFloat  space = MSWidth - 150*KFontmultiple*2 - 50;
    model.orignx = [NSNumber numberWithFloat:index * (space+ 150*KFontmultiple)+25];
    NSLog(@"origny:%f", page  * (baseViewHeight + 40)+10);
    model.origny = [NSNumber numberWithFloat: page  * (baseViewHeight + 40)+10];
    model.orignwidth = [NSNumber numberWithFloat:150*KFontmultiple];
    model.orignheight = [NSNumber numberWithFloat:150*KFontmultiple +20];
    model.minNumber = @"0";
    model.maxNumber = @"100";
    model.infoLabeltext = @"add";
    /**
     存储.
     */
    customDash.dashboardA = model;
    customDash.dashboardType = 1;
    [model bg_saveAsync:^(BOOL isSuccess) {
        NSLog(@"存储成功");
    }];
}
- (void)initADDdashboardB:(DashboardB *)dash withTag:(NSInteger)i{
    DashboardB *model = [DashboardB new];
    model.ValueColor  = @"#FFFFFF";
    model.ValueFontScale = [NSNumber numberWithFloat:1.f];
    model.ValuePositon = [NSNumber numberWithFloat:1.f];
    model.ValueVisible = YES;
    model.titleColor  = @"#757476";
    model.titleFontScale = [NSNumber numberWithFloat:1.f];
    model.titlePositon = [NSNumber numberWithFloat:1.f];
    
    model.UnitColor = @"#757476";
    model.UnitFontScale = [NSNumber numberWithFloat:1.f];
    model.UnitPositon = [NSNumber numberWithFloat:1.f];
    
    
    model.backColor = @"00a6ff";
    model.GradientRadius = [NSNumber numberWithFloat:MSWidth/2];
    
    model.FillColor = @"FE9002";
    model.FillEnable = YES;
    
    model.Pointerwidth = [NSNumber numberWithFloat:1.f];
    model.pointerColor = @"#FFFFFF";
    model.orignx = [NSNumber numberWithFloat:MSWidth+ MSWidth/2 - 100];
    model.origny = [NSNumber numberWithFloat:i  * (220+ 30)+30];
    model.orignwidth = [NSNumber numberWithFloat:220];
    model.orignheight = [NSNumber numberWithFloat:220];
    
    model.minNumber = @"0";
    model.maxNumber = @"100";
    model.infoLabeltext = @"add";
    
    /**
     存储.
     */
    CustomDashboard *customDash = [CustomDashboard new];
    customDash.dashboardB = model;
    customDash.dashboardType = 1;
    [model bg_saveAsync:^(BOOL isSuccess) {
        NSLog(@"存储成功");
    }];
}
- (void)initADDdashboardC:(DashboardC *)dash withTag:(NSInteger)i{
    DashboardC *model = [DashboardC new];
    model.UnitColor = @"FFFFFF";
    model.UnitFontScale = [NSNumber numberWithFloat:1.f];
    model.UnitPositon = [NSNumber numberWithFloat:1.f];
    
    model.FrameColor = @"FFFFFF";
    model.titlePositon = [NSNumber numberWithFloat:1.f];
    model.titleFontScale =[NSNumber numberWithFloat:1.f];
    model.titleColor = @"FFFFFF";
    
    model.ValueColor = @"FFFFFF";
    model.ValueFontScale = [NSNumber numberWithFloat:1.f];
    model.ValuePositon = [NSNumber numberWithFloat:1.f];
    model.ValueVisible = YES;
    model.innerColor = @"000000";
    model.outerColor = @"000000";
    model.Gradientradius = [NSNumber numberWithFloat:MSWidth/2];
    model.orignx = [NSNumber numberWithFloat:MSWidth*2+(MSWidth- 300)/2];
    model.origny = [NSNumber numberWithFloat:88];
    model.orignwidth = [NSNumber numberWithFloat:300];
    model.orignheight = [NSNumber numberWithFloat:300];
    
    model.minNumber = @"0";
    model.maxNumber = @"100";
    model.infoLabeltext = @"add";
    
    /**
     存储.
     */
    CustomDashboard *customDash = [CustomDashboard new];
    customDash.dashboardC = model;
    customDash.dashboardType = 1;
    [model bg_saveAsync:^(BOOL isSuccess) {
        NSLog(@"存储成功");
    }];
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
