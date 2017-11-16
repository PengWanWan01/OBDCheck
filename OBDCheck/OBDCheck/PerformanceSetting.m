//
//  PerformanceSetting.m
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import "PerformanceSetting.h"

@implementation PerformanceSetting
#pragma mark - 单例
+ (instancetype)sharedInstance {
    static PerformanceSetting *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[PerformanceSetting alloc] init];
        
    });
    return _sharedClient;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        [self.defaults setObject:@"100" forKey:@"endSpeed"];
        [self.defaults setObject:@"0" forKey:@"startSpeed"];
        [self.defaults synchronize];

    }
    return self;
}
@end
