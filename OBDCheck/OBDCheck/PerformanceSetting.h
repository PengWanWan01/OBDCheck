//
//  PerformanceSetting.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/11/15.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PerformanceSetting : NSObject
@property (nonatomic,strong)   NSUserDefaults* defaults;
//单例模式，实例化对象
+(instancetype )sharedInstance;
@end
