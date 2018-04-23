//
//  ViewController.h
//  OBDCheck
//
//  Created by yutaozhao on 2017/7/31.
//  Copyright © 2017年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueToothController.h"

@interface ViewController : TheBasicViewController

//蓝牙管理类
@property (nonatomic,strong) BlueToothController *blueTooth ;
@end

