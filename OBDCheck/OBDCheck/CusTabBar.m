//
//  CusTabBar.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/1/3.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "CusTabBar.h"
@interface CusTabBar () <UITabBarControllerDelegate>

@end
@implementation CusTabBar
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabbarType = 0;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
      [[UITabBar appearance] setBarTintColor:[ColorTools colorWithHexString:@"#3B3F49"]];
        [UITabBar appearance].translucent = NO;
}
-(void)initWithView{
    
    switch (self.tabbarType) {
        case 0:
        {
            DiagController *vc1 = [[DiagController alloc]init];
            vc1.tabBarItem.image=[UIImage imageNamed:@"troubleCode_normal"];
            vc1.tabBarItem.selectedImage=[UIImage imageNamed:@"troubleCode_highLight"];
            UINavigationController *NVC1 = [[UINavigationController alloc]initWithRootViewController:vc1];
            NVC1.tabBarItem.title = @"121";
            FreezeViewController *vc2 = [[FreezeViewController alloc]init];
            vc2.tabBarItem.image=[UIImage imageNamed:@"freeze_normal"];
            vc2.tabBarItem.selectedImage=[UIImage imageNamed:@"Freeze_highlight"];
            UINavigationController *NVC2 = [[UINavigationController alloc]initWithRootViewController:vc2];
            ReadinessViewController *vc3 = [[ReadinessViewController alloc]init];
            vc3.tabBarItem.image=[UIImage imageNamed:@"readiness_normal"];
            vc3.tabBarItem.selectedImage=[UIImage imageNamed:@"readiness_highLight"];
            UINavigationController *NVC3 = [[UINavigationController alloc]initWithRootViewController:vc3];
            ReportViewController *vc4 = [[ReportViewController alloc]init];
            vc4.tabBarItem.image=[UIImage imageNamed:@"report_normal"];
            vc4.tabBarItem.selectedImage=[UIImage imageNamed:@"report_highLight"];
            UINavigationController *NVC4 = [[UINavigationController alloc]initWithRootViewController:vc4];
            self.viewControllers = @[NVC1,NVC2,NVC3,NVC4];
        }
            break;
        case 1:
        {
            MonController *vc1 = [[MonController alloc]init];
            vc1.tabBarItem.image=[UIImage imageNamed:@"monitor_normal"];
            vc1.tabBarItem.selectedImage=[UIImage imageNamed:@"monitor_highlight"];
            UINavigationController *NVC1= [[UINavigationController alloc]initWithRootViewController:vc1];
            Sensors2ViewController *vc2 = [[Sensors2ViewController alloc]init];
            vc2.tabBarItem.image=[UIImage imageNamed:@"Sensor_normal"];
            vc2.tabBarItem.selectedImage=[UIImage imageNamed:@"Sensor_highlight"];
            UINavigationController *NVC2 = [[UINavigationController alloc]initWithRootViewController:vc2];
            Mode06ViewController *vc3 = [[Mode06ViewController alloc]init];
            vc3.tabBarItem.image=[UIImage imageNamed:@"Mode06_normal"];
            vc3.tabBarItem.selectedImage=[UIImage imageNamed:@"Mode06_highlight"];
            UINavigationController *NVC3 = [[UINavigationController alloc]initWithRootViewController:vc3];
            Mode09ViewController *vc4 = [[Mode09ViewController alloc]init];
            vc4.tabBarItem.image=[UIImage imageNamed:@"Mode09_normal"];
            vc4.tabBarItem.selectedImage=[UIImage imageNamed:@"Mode09_highlight"];
            UINavigationController *NVC4 = [[UINavigationController alloc]initWithRootViewController:vc4];
            self.viewControllers = @[NVC1,NVC2,NVC3,NVC4];

        }
            break;
        case 2:
        {
            LogsController *vc1 = [[LogsController alloc]init];
            vc1.tabBarItem.image=[UIImage imageNamed:@"Graphs_normal"];
            vc1.tabBarItem.selectedImage=[UIImage imageNamed:@"Graphs_highlight"];
            UINavigationController *NVC1 = [[UINavigationController alloc]initWithRootViewController:vc1];
            NVC1.tabBarItem.title = @"Graphs";
            TripsViewController *vc2 = [[TripsViewController alloc]init];
            vc2.tabBarItem.image=[UIImage imageNamed:@"trips_normal"];
            vc2.tabBarItem.selectedImage=[UIImage imageNamed:@"trips_highlight"];
            UINavigationController *NVC2= [[UINavigationController alloc]initWithRootViewController:vc2];
            NVC2.tabBarItem.title = @"Trips";
            FilesViewController *vc3 = [[FilesViewController alloc]init];
            vc3.tabBarItem.image=[UIImage imageNamed:@"file_normal"];
            vc3.tabBarItem.selectedImage=[UIImage imageNamed:@"file_highlight"];
            UINavigationController *NVC3 = [[UINavigationController alloc]initWithRootViewController:vc3];
            NVC3.tabBarItem.title = @"Files";
            self.viewControllers = @[NVC1,NVC2,NVC3];
            
        }
            break;
        default:
            break;
    }
}
@end
