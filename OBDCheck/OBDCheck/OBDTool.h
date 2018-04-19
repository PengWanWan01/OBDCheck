//
//  OBDTool.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/9.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBDTool : OBDCHECKLIBOC

//单例模式，实例化对象
+(instancetype )sharedInstance;
@end
