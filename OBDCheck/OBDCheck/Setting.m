//
//  Setting.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "Setting.h"

@implementation Setting
#pragma mark - 单例
+ (instancetype)sharedInstance {
    static Setting *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[Setting alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        [self.defaults setObject:@"140" forKey:@"SpeedAlarm"];
        [self.defaults setObject:@"110" forKey:@"WaterTemperatureAlarm"];
        [self.defaults setObject:@"3" forKey:@"DriverFatigueAlarm"];
        [self.defaults synchronize];
    }
    return self;
}
@end
