//
//  LogsModel.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/9/12.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogsModel : NSObject
@property (nonatomic,copy) NSString *item1PID;
@property (nonatomic,assign) BOOL item1Smoothing;

@property (nonatomic,copy) NSString *item2PID;
@property (nonatomic,assign) BOOL item2Smoothing;

@property (nonatomic,copy) NSString *item3PID;
@property (nonatomic,assign) BOOL item3Enabled;
@property (nonatomic,assign) BOOL item3Smoothing;

@property (nonatomic,copy) NSString *item4PID;
@property (nonatomic,assign) BOOL item4Enabled;
@property (nonatomic,assign) BOOL item4Smoothing;
@end