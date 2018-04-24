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
        BOOL flag1 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS CustomDashboard (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
//        BOOL flag2 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS troubleCodeModel (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
//        BOOL flag3 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS LogsModel (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
//        BOOL flag4 = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS TripsModel (id INTEGER PRIMARY KEY AUTOINCREMENT,data TEXT);"];
        if (flag1 ) {
            NSLog(@"表创建成功");
        } else {
            NSLog(@"表创建失败");
        }
    }];
    
    
}
//增
- (void)insert:(NSString *)SQL{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL    flag = [db executeUpdate:SQL];
        if (flag) {
            NSLog(@"数据插入成功");
        } else {
            NSLog(@"数据插入失败");
        }
    }];
}
//删
- (void)Delete:(NSString *)SQL{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL flag = [db executeUpdate:SQL];
        if (flag) {
            NSLog(@"数据删除成功");

        } else {
            NSLog(@"数据删除失败");
        }
    }];
}
//改
- (void)update:(NSString *)SQL{
    
    __block BOOL flag;
    [_queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        @try {
            flag =   [db executeUpdate:SQL];
            
        } @catch (NSException *exception) {
            *rollback = YES;
            flag = NO;
            
        } @finally {
            *rollback=!flag;
        }
    }];
}
//查
- (NSMutableArray *)find:(NSString *)str{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM CustomDashboard %@",str];
        FMResultSet *result = [db executeQuery:SQL];
        
        while ([result next]) {
            CustomDashboard *person = [[CustomDashboard alloc] init];
            person = [CustomDashboard yy_modelWithJSON:[result stringForColumn:@"data"]];
            [dataArray addObject:person];
        }
    }];
    
    return dataArray;
    
}
-(CustomDashboard *)findByPK:(NSInteger )ID{
    
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    [_queue inDatabase:^(FMDatabase *db) {
        NSString *SQL = [NSString stringWithFormat:@"SELECT * FROM CustomDashboard WHERE id = %ld",(long)ID];
        FMResultSet *result = [db executeQuery:SQL];
        while ([result next]) {

        CustomDashboard *person = [[CustomDashboard alloc] init];
        person = [CustomDashboard yy_modelWithJSON:[result stringForColumn:@"data"]];
        [dataArray addObject:person];
        }
    }];
    return dataArray.lastObject;
}
//查
- (NSMutableArray *)findAll{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * FROM CustomDashboard;"];
        
        while ([result next]) {
            CustomDashboard *person = [[CustomDashboard alloc] init];
            person = [CustomDashboard yy_modelWithJSON:[result stringForColumn:@"data"]];
            [dataArray addObject:person];
        }
    }];
    DLog(@"%@",dataArray);
    return dataArray;
    
}
@end
