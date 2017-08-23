//
//  DashboardSetting.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/16.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "DashboardSetting.h"


@implementation DashboardSetting
#pragma mark - 单例
+ (instancetype)sharedInstance {
    static DashboardSetting *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DashboardSetting alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
         self.defaults = [NSUserDefaults standardUserDefaults];
        self.dashboardMode = DashboardCustomMode;
        self.dashboardStyle = DashboardStyleOne;
        self.numberDecimals = NumberDecimalZero;
        self.multiplierType = MultiplierType1;
        self.hudModeType = HUDModeTypeToNormal;
        self.KPageNumer = 3;
        self.AddDashboardNumber = 0;
        self.isDashboardFont = NO;
        self.isDashboardMove = NO;
        self.isDashboardRemove = NO;
        self.RemoveDashboardNumber = 0;
//         [self.defaults setObject:@"11" forKey:[NSString stringWithFormat:@"test%ld",[DashboardSetting sharedInstance].Dashboardindex]];
    
    }
    return self;
}
-(void)SetDefultAttribute
{
    
    self.dashboardMode = DashboardClassicMode;
}


-(BOOL)SetAttribute:(CGFloat )Value Key:(NSString *)key
{
    //加入本地设置参数
    [self.defaults setFloat:Value forKey:[NSString stringWithFormat:@"%@",key]];
    
    return YES;
}

-(CGFloat )GetAttribute:(NSString *)Key
{
    //获取本地文件相关属性的值
    CGFloat result = [self.defaults floatForKey:[NSString stringWithFormat:@"%@",Key]];
    
    if (!result) {
        return 100.f;
    }
    return result;
}

@end
