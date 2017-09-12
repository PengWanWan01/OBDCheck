//
//  LogsSetting.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/12.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogsSetting : NSObject
@property (nonatomic,strong)   NSUserDefaults* defaults;
-(void)initWithlogs;
//单例模式，实例化对象
+(instancetype )sharedInstance;
@end
