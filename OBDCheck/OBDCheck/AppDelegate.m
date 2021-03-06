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
   

     NSArray *pll1 =    [[OBDataModel sharedDataBase] findTable:@"Dashboards" withConditionStr:@"WHERE id > 27"];
    for (CustomDashboard *dsh in pll1) {
         DLog(@"出%ld,%ld,%@,%@",dsh.ID,dsh.dashboardType, dsh.DashboardPID,dsh.Dashboardorignx);
    }
    NSArray *pll =  [[OBDataModel sharedDataBase]findTableAll:@"Dashboards"];
    for (CustomDashboard *dash in pll) {
        NSLog(@"%ld,%ld, %@",(long)dash.ID,dash.dashboardType, dash.Dashboardorignx);
    }
//    [UIApplication sharedApplication].idleTimerDisabled =YES; //让屏幕常亮

    // Override point for customization after application launch.
    //testViewController
    ViewController *ROOTVC = [[ViewController alloc]init];
    UINavigationController *NAC = [[UINavigationController alloc]initWithRootViewController:ROOTVC];
    NAC.navigationBar.shadowImage=[ColorTools imageWithColor:[UIColor whiteColor] size:CGSizeMake(MSWidth, 1)];
      
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window setRootViewController:NAC];
    self.window.backgroundColor = [ColorTools colorWithHexString:@"#212329"];
    [self.window makeKeyAndVisible];
    [UITabBar appearance].backgroundColor = [ColorTools colorWithHexString:@"3B3F49"];
    [UITabBar appearance].tintColor = [ColorTools colorWithHexString:@"#FE9002"];
    
    //      加载C语言库
//    [self loadCFile];
    //在后台也可以播放声音
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    return YES;
}
- (void)loadCFile{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ExtFlashDat" ofType:@"bin"];
    //获取数据
    NSData  *reader = [NSData dataWithContentsOfFile:path];//调用OBDCHECKLIBOC的LoadPublicLIB2OCBufP加载文件之前，必须要先打开文件
//    Byte *byt = (Byte *)[reader bytes];
    //偶尔会蹦
    if([[OBDLibTools sharedInstance] LoadPublicLIB2OCBufP:reader])  //step1:加载库成功
    {
        [OBDLibTools sharedInstance].LoadSuccess = YES;
        DLog(@"加载成功");
        [[OBDLibTools sharedInstance]PrsCmdLoadPublicBufOCInput:inputData withOutPut:outputData];
        //添加一个一直运转的子线程
        NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(newThread) object:nil];
        [thread start];
        //添加收到的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewNumber:) name:@"send" object:nil];
    }
    //在程序杀死时候释放
}
- (void)newThread
{
    @autoreleasepool
    {
        [NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(addTime) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}
//收到
- (void)getNewNumber:(NSNotification *)text{
    DLog(@"收到%@",text);
    NSString *presentStr = [NSString stringWithFormat:@"%@", [text.userInfo objectForKey:@"Tag"]];
    [OBDLibTools sharedInstance].MessageVal = [presentStr intValue];
}

- (void)addTime{
    [[OBDLibTools sharedInstance]MainOC];
}
- (void)initWithdatabase{
    [[UserDefaultSet sharedInstance]SetDefultAttribute]; //设置默认属性,分数据库部分    
    [[DashboardSetting sharedInstance]initWithdashboardA];
    [[DashboardSetting sharedInstance]initWithdashboardB];
    [[DashboardSetting sharedInstance]initWithdashboardC];
    [[DashboardSetting sharedInstance]initWithHudColor];
//    [[LogsSetting sharedInstance]initWithTrips];
    [[DashboardSetting sharedInstance]initwithCustomDashboard];
    
}


- (void)clearAllUserDefaultsData
{
    [[UserDefaultSet sharedInstance] SetDefultAttribute];
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
     [[OBDLibTools sharedInstance] freeBufOC];//在使用完OBDCHECKLIBOC之后，一定要调用freeBufOC来释放在使用的过程中分配的内存
}


@end
