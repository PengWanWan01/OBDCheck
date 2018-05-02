//
//  OBDataModel.m
//  OBDCheck
//
//  Created by yutaozhao on 2018/4/20.
//  Copyright © 2018年 Auptophix. All rights reserved.
//

#import "OBDataModel.h"
static OBDataModel *_DBCtl = nil;
@interface OBDataModel()<NSCopying,NSMutableCopying>

@property (nonatomic,strong) FMDatabaseQueue *queue;

@end
@implementation OBDataModel
+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[OBDataModel alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"model1.sqlite"];
    
    // 实例化FMDataBase对象
    
    _queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    
    
    // 初始化数据表
    
    
    [_queue inDatabase:^(FMDatabase * _Nonnull db) {
        //创建数据表
        BOOL flag1 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Dashboards (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
        BOOL flag2 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS troubleCodes (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
        BOOL flag3 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Logs (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
        BOOL flag4 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS Trips (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
         BOOL flag5 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS HUDs (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
        if (flag1 && flag2 && flag3 && flag4 && flag5) {
            NSLog(@"表创建成功");
        } else {
            NSLog(@"表创建失败");
        }
    }];
    
    
}
//增
- (void)insertTableName:(NSString *)tableName withdata:(NSString *)data{
    [_queue inDatabase:^(FMDatabase *db) {
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT INTO %@ (data) VALUES ('%@')",tableName,data];
        BOOL    flag = [db executeUpdate:SQLStr];
        if (flag) {
            NSLog(@"数据插入成功");
        } else {
            NSLog(@"数据插入失败");
        }
    }];
}
//删
- (void)DeleteTableName:(NSString *)tableName withID:(NSInteger )ID
{
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *SQLStr = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %ld",tableName,ID];
        BOOL flag = [db executeUpdate:SQLStr];
        if (flag) {
            NSLog(@"数据删除成功");

        } else {
            NSLog(@"数据删除失败");
        }
    }];
}
- (void)dropTable:(NSString *)tableName{
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *SQLStr = [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@",tableName];
        BOOL flag = [db executeUpdate:SQLStr];
        if (flag) {
            NSLog(@"成功清除%@",tableName);
        } else {
            NSLog(@"清除失败");
        }
    }];
}
//改
- (void)updateTableName:(NSString *)tableName  withdata:(NSString *)data withID:(NSInteger )ID{
    __block BOOL flag;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        @try {
            NSString *str = [NSString stringWithFormat:@"UPDATE %@ SET (data) = ('%@')  WHERE id = %ld ",tableName,data ,(long)ID];
            flag =   [db executeUpdate:str];
            
            
        } @catch (NSException *exception) {
            *rollback = YES;
            flag = NO;
            
        } @finally {
            *rollback=!flag;
        }
    }];
}
//查
- (NSMutableArray *)findTable:(NSString *)tableName withConditionStr:(NSString *)str{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,str];
        FMResultSet *result = [db executeQuery:SQL];
        while ([result next]) {
            if ([tableName isEqualToString:@"Dashboards"]) {
                CustomDashboard *person = [[CustomDashboard alloc] init];
                person = [CustomDashboard yy_modelWithJSON:[result stringForColumn:@"data"]];
                 [dataArray addObject:person];
            }else if ([tableName isEqualToString: @"HUDs"]){
                HUDSet *person = [[HUDSet alloc] init];
                person = [HUDSet yy_modelWithJSON:[result stringForColumn:@"data"]];
                 [dataArray addObject:person];
            }
           
        }
    }];
    
    return dataArray;
    
}
-(NSMutableArray *)findTable:(NSString *)tablename withID:(NSInteger )ID{
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE id = %ld",tablename,(long)ID];
        FMResultSet *result = [db executeQuery:SQL];
        while ([result next]) {

            if ([tablename isEqualToString:@"Dashboards"]) {
                CustomDashboard *person = [[CustomDashboard alloc] init];
                person = [CustomDashboard yy_modelWithJSON:[result stringForColumn:@"data"]];
                [dataArray addObject:person];
            }else if ([tablename isEqualToString: @"HUDs"]){
                HUDSet *person = [[HUDSet alloc] init];
                person = [HUDSet yy_modelWithJSON:[result stringForColumn:@"data"]];
                [dataArray addObject:person];
            }
        }
    }];
    return dataArray;
}
//查
- (NSMutableArray *)findTableAll:(NSString *)tablename{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM %@",tablename];
        FMResultSet *result = [db executeQuery:sqlStr];
        
        while ([result next]) {
            if ([tablename isEqualToString:@"Dashboards"]) {
                CustomDashboard *person = [[CustomDashboard alloc] init];
                person = [CustomDashboard yy_modelWithJSON:[result stringForColumn:@"data"]];
                [dataArray addObject:person];
            }else if ([tablename isEqualToString: @"HUDs"]){
                HUDSet *person = [[HUDSet alloc] init];
                person = [HUDSet yy_modelWithJSON:[result stringForColumn:@"data"]];
                [dataArray addObject:person];
            }
        }
    }];
    DLog(@"%@",dataArray);
    return dataArray;
    
}
@end
