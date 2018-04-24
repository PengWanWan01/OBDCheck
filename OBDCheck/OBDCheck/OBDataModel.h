//
//  OBDataModel.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/20.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OBDataModel : NSObject
+ (instancetype)sharedDataBase;
//增
- (void)insert:(NSString *)SQL;
//删
- (void)Delete:(NSString *)SQL;
//改
- (void)update:(NSString *)SQL;
//查
- (NSMutableArray *)find:(NSString *)str;
-(CustomDashboard *)findByPK:(NSInteger )ID;
- (NSMutableArray *)findAll;
- (void)initDataBase;
@end
