//
//  LogsController.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/8/1.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogsController : UIViewController
//蓝牙管理类
@property (nonatomic,strong) BlueToothController *blueTooth ;

- (void)startBtn;
- (void)stopBtn;
@end
