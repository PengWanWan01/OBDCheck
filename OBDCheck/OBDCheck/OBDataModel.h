//
//  OBDataModel.h
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/20.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger ,tableType)
{
    Dashboards,   // 仪表盘表格
    troubleCodes, //故障码表格
    Logs,          //logs表格
    Trips,         //行程表格
    vehicle        //车辆表格
};
@interface OBDataModel : NSObject
+ (instancetype)sharedDataBase;

/**
 通过表名插入内容到表中

 @param tableName 表名
 @param data 插入的内容
 */
- (void)insertTableName:(NSString *)tableName withdata:(NSString *)data;


/**
 通过表名和ID删除表中某个ID

 @param tableName 表名
 @param ID ID
 */
- (void)DeleteTableName:(NSString *)tableName withID:(NSInteger )ID;

/**
 通过表名于ID更新表的内容

 @param tableName 表名
 @param data 更新的内容
 @param ID ID
 */
- (void)updateTableName:(NSString *)tableName  withdata:(NSString *)data withID:(NSInteger )ID;


/**
 通过条件查找表的内容,以数组的形式显示完全

 @param tableName 表名
 @param str 条件
 @return 查找到的结果
 */
- (NSMutableArray *)findTable:(NSString *)tableName withConditionStr:(NSString *)str;


/**
 通过ID查找表的内容,以数组只有一个元素,记得去取最后或者第一个元素,最后或者第一个元素则为你需要的模型

 @param tablename 表名
 @param ID ID值
 @return 数组
 */
-(NSMutableArray *)findTable:(NSString *)tablename withID:(NSInteger )ID;


/**
 通过表名查找表内所有的元素
 
 @param tablename 表名
 @return 以数组的形式返回
 */
- (NSMutableArray *)findTableAll:(NSString *)tablename;


/**
 将表彻底删除,下次使用需要重建

 @param tableName 表名
 */
- (void)dropTable:(NSString *)tableName;

- (void)initDataBase;
@end
