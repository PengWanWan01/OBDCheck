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
@property (nonatomic,assign) BOOL PID1Smoothing; //第一条PID是否光滑
@property (nonatomic,assign) BOOL PID2Smoothing; //第二条PID是否光滑
@property (nonatomic,assign) BOOL PID3Smoothing; //第三条PID是否光滑
@property (nonatomic,assign) BOOL PID3Enable; //第三条PID是否可用
@property (nonatomic,assign) BOOL PID4Smoothing; //第四条PID是否光滑
@property (nonatomic,assign) BOOL PID4Enable; //第四条PID是否可用


//单例模式，实例化对象
+(instancetype )sharedInstance;
- (void)initWithTrips;
- (void)initWithlogswith:(NSArray *)PID1data with:(NSArray *)PID2data with:(NSArray *)PID3data with:(NSArray *)PID4data;

@end
