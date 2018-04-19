//
//  UserDefaultSet.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/19.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "UserDefaultSet.h"

@implementation UserDefaultSet
#pragma mark - 单例
+ (instancetype)sharedInstance {
    static UserDefaultSet *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[UserDefaultSet alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        //                [self.defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:myObject] forKey:@"MyObjectKey"];
        [self.defaults synchronize];
    }
    return self;
}
-(void)SetDefultAttribute
{
    self.dashboardMode = DashboardCustomMode;
    self.dashboardStyle = DashboardStyleOne;
    self.numberDecimals = NumberDecimalZero;
    self.multiplierType = MultiplierType1;
    self.backConnect = backgroundConnectON;
    self.alarm = AlarmON;
    self.keepScreen = keepScreenON;
    self.keeptips = keepScreenON;
    self.launchDashboard = LaunchDashboardON;

    [self SetAttribute:self.dashboardMode Key:@"dashboardMode"];
    [self SetAttribute:self.dashboardStyle Key:@"dashboardStyle"];
    [self SetAttribute:self.numberDecimals Key:@"numberDecimals"];
    [self SetAttribute:self.multiplierType Key:@"multiplierType"]; //
    [self SetAttribute:self.backConnect Key:@"backConnect"]; //
    [self SetAttribute:self.alarm Key:@"alarm"];
    [self SetAttribute:self.alarm Key:@"keepScreen"];
    [self SetAttribute:self.keeptips Key:@"keeptips"];
    [self SetAttribute:self.launchDashboard Key:@"launchDashboard"];

}
-(BOOL)SetAttribute:(NSInteger )Value Key:(NSString *)key
{
    
    //加入本地设置参数
    [self.defaults setInteger:Value forKey:[NSString stringWithFormat:@"%@",key]];
    DLog(@"存入沙河");
    return YES;
}

-(NSInteger )GetAttribute:(NSString *)Key
{
    //获取本地文件相关属性的值
    NSInteger result = [self.defaults  integerForKey:[NSString stringWithFormat:@"%@",Key]];
    DLog(@"取出沙河%ld",(long)result);

    return result;
}
@end
