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
    self.KPageNumer = 3;
    self.ScreenshotData = [[NSString alloc]init];
    self.hudModeType = HUDModeTypeToNormal;
    self.HUDColourStr = @"44FF00";
    self.LogsModel = [LogsSetting new];
    [self SetIntegerAttribute:self.dashboardMode Key:@"dashboardMode"];
    [self SetIntegerAttribute:self.dashboardStyle Key:@"dashboardStyle"];
    [self SetIntegerAttribute:self.numberDecimals Key:@"numberDecimals"];
    [self SetIntegerAttribute:self.multiplierType Key:@"multiplierType"]; //
    [self SetIntegerAttribute:self.backConnect Key:@"backConnect"]; //
    [self SetIntegerAttribute:self.alarm Key:@"alarm"];
    [self SetIntegerAttribute:self.alarm Key:@"keepScreen"];
    [self SetIntegerAttribute:self.keeptips Key:@"keeptips"];
    [self SetIntegerAttribute:self.launchDashboard Key:@"launchDashboard"];
    [self SetIntegerAttribute:self.KPageNumer Key:@"KPageNumer"];
    [self SetIntegerAttribute:self.hudModeType Key:@"hudModeType"];

    [self SetStringAttribute:self.ScreenshotData Key:@"ScreenshotData"];
    [self SetStringAttribute:self.HUDColourStr Key:@"HUDColourStr"];
    [self SetStringAttribute:[self.LogsModel yy_modelToJSONString] Key:@"LogsModel"];

}
-(BOOL)SetIntegerAttribute:(NSInteger )Value Key:(NSString *)key
{
    
    //加入本地设置参数
    [self.defaults setInteger:Value forKey:[NSString stringWithFormat:@"%@",key]];
    DLog(@"存入沙河");
    return YES;
}

-(NSInteger )GetIntegerAttribute:(NSString *)Key
{
    //获取本地文件相关属性的值
    NSInteger result = [self.defaults  integerForKey:[NSString stringWithFormat:@"%@",Key]];
    DLog(@"取出沙河%ld",(long)result);

    return result;
}
-(BOOL)SetStringAttribute:(NSString * )Value Key:(NSString *)key{
    //加入本地设置参数
    [self.defaults setObject:Value forKey:[NSString stringWithFormat:@"%@",key]];
    DLog(@"存入沙河");
    return YES;    
}
-(NSString *)GetStringAttribute:(NSString *)Key{
    //获取本地文件相关属性的值
    NSString *result = [self.defaults  objectForKey:[NSString stringWithFormat:@"%@",Key]];
    DLog(@"取出沙河%@",result);
    
    return result;
    
}
@end
