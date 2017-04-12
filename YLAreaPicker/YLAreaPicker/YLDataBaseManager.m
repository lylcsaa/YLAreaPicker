//
//  DataBaseManager.m
//  CASMagazine
//
//  Created by smn on 17/3/14.
//  Copyright © 2017年 Tim. All rights reserved.
//

#define K_DOCUMENT_PATH NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0]
#define knumber  @"123456789"
#import "YLDataBaseManager.h"
#import "FMDB.h"
@interface YLDataBaseManager ()

@property(nonatomic, strong) FMDatabase *fmdb;// 数据库对象
@property (nonatomic , strong) FMDatabaseQueue *dataBaseQueue;
/**
 **:数据库名称
 **/
@property (nonatomic,copy)NSString *name;
@end

@implementation YLDataBaseManager
+(YLDataBaseManager *)shareManager
{
    static YLDataBaseManager *dbManager = nil;
    if (!dbManager) {
        dbManager = [[YLDataBaseManager alloc] init];
    }
    return dbManager;
}
-(NSString*)getBaseLocalPath
{
    NSString *phoneNumber = knumber;
    if (!phoneNumber) {
        return nil;
    }
    self.name = [NSString stringWithFormat:@"%@/council.sqlite", phoneNumber];
    NSString *localDbPath = [K_DOCUMENT_PATH stringByAppendingPathComponent:self.name];
    return localDbPath;
}

-(NSString*)getUserDirectoryPath
{
    NSString *phoneNumber = knumber;
    if (!phoneNumber) {
        return nil;
    }
    return [K_DOCUMENT_PATH stringByAppendingPathComponent:phoneNumber];
}
-(BOOL)isCurrentDataBase
{
    NSString *dbPath = [self getBaseLocalPath];
    NSLog(@">>>>>:本地数据库路径path = %@",dbPath);
    if (!dbPath) {
        return NO;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        return [self creatDataBaseQueueByPath:dbPath];
    }
    BOOL isDir = NO;/**<是否是文件夹*/
    NSString *dirPath = [self getUserDirectoryPath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir] || !isDir) {
        NSError *error;
        [[NSFileManager defaultManager]createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"创建文件路径失败");
            return NO;
        }
    }
    NSString *bandlePath = [[NSBundle mainBundle] pathForResource:@"counci" ofType:@".sqlite"];
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtPath:bandlePath toPath:dbPath error:&error];
    if (error) {
        NSLog(@"拷贝数据库失败");
        return NO;
    }
    return [self creatDataBaseQueueByPath:dbPath];;
}
-(BOOL)creatDataBaseQueueByPath:(NSString*)localDbBase
{
 
    if (self.dataBaseQueue && [self.dataBaseQueue.path isEqualToString:localDbBase]) {
        return YES;
    }
    [self.dataBaseQueue close];
    self.dataBaseQueue = nil;
    self.dataBaseQueue = [FMDatabaseQueue databaseQueueWithPath:localDbBase];
    return YES;
}

-(void)insertAreaByArr:(NSArray *)arr tag:(int)tag
{   [self isCurrentDataBase];
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            BOOL isRollBack = NO;
            @try {
                for (NSDictionary *dict in arr) {
                    NSString *sql = nil;
                    BOOL res = NO;
                    switch (tag) {
                        case 1:
                            sql = @"INSERT INTO provence (areaid, areaname) VALUES(?, ?)";
                            res = [db executeUpdate:sql,dict[@"areaCode"],dict[@"name"]];
                            if (!res) {
                                NSLog(@"");
                            }

                            break;
                        case 2:
                            sql = @"INSERT INTO city (areaid, name,superid) VALUES(?, ?, ?)";
                            res = [db executeUpdate:sql,dict[@"areaCode"],dict[@"name"],dict[@"fcode"]];
                            if (!res) {
                                NSLog(@"");
                            }

                            break;
                        case 3:
                            sql = @"INSERT INTO area (areaid, areaname,superid) VALUES(?, ?, ?)";
                            res = [db executeUpdate:sql,dict[@"areaCode"],dict[@"name"],dict[@"fcode"]];
                            if (!res) {
                                NSLog(@"");
                            }

                            break;
                        case 4:
                            sql = @"INSERT INTO street (areaid, areaname,superid) VALUES(?, ?, ?)";
                            res = [db executeUpdate:sql,dict[@"areaCode"],dict[@"name"],dict[@"fcode"]];
                            if (!res) {
                                NSLog(@"");
                            }

                            break;
                        default:
                            break;
                    }
                }
            } @catch (NSException *exception) {
                isRollBack = YES;
                [db rollback];
            } @finally {
                isRollBack = YES;
                [db commit];
            }
            
            
        }else{
            NSLog(@"插入失败");
        }
    }];


}
#pragma mark - 查询订阅表
-(NSArray*)queryProvenceByTable
{
    if (![self isCurrentDataBase]) {
        return nil;
    }
    
    __block NSMutableArray *array = [NSMutableArray array];
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql;
            sql = @"SELECT *FROM provence";
            FMResultSet *rs = [db executeQuery:sql];
            while ([rs next]) {
                NSString *name = [rs stringForColumn:@"areaname"];
                long long _id = [rs longLongIntForColumn:@"areaid"];
                YLProvence *p = [[YLProvence alloc] init];
                p._id = _id;
                p.pname = name;
                [array addObject:p];
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
    return array;
}
-(NSArray*)queryCityBySuperId:(NSInteger)pid
{
    if (![self isCurrentDataBase]) {
        return nil;
    }
    
    __block NSMutableArray *array = [NSMutableArray array];
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql;
            sql = @"SELECT *FROM city WHERE superid = ?";
            FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInteger:pid]];
            while ([rs next]) {
                
                YLCity *c = [[YLCity alloc] init];
                c._id = [rs longLongIntForColumn:@"areaid"];
                c.cname = [rs stringForColumn:@"name"];
                c.super_id = [rs longLongIntForColumn:@"superid"];
                [array addObject:c];
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
    return array;
}
-(NSArray*)queryAreaBySuperId:(NSInteger)cid
{
    if (![self isCurrentDataBase]) {
        return nil;
    }
    
    __block NSMutableArray *array = [NSMutableArray array];
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql;
            sql = @"SELECT *FROM area WHERE superid = ?";
            FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInteger:cid]];
            while ([rs next]) {
                
                YLArea *c = [[YLArea alloc] init];
                c._id = [rs longLongIntForColumn:@"areaid"];
                c.aname = [rs stringForColumn:@"areaname"];
                c.super_id = [rs longLongIntForColumn:@"superid"];
                [array addObject:c];
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
    return array;
}
-(NSArray*)queryStreetBySuperId:(NSInteger)sid
{
    if (![self isCurrentDataBase]) {
        return nil;
    }
    
    __block NSMutableArray *array = [NSMutableArray array];
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql;
            sql = @"SELECT *FROM street WHERE superid = ?";
            FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInteger:sid]];
            while ([rs next]) {
                
                YLStreet *c = [[YLStreet alloc] init];
                c._id = [rs longLongIntForColumn:@"areaid"];
                c.sname = [rs stringForColumn:@"areaname"];
                c.super_id = [rs longLongIntForColumn:@"superid"];
                [array addObject:c];
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
    return array;
}
#pragma mark 根据ID查询每个地区
-(YLProvence*)queryProvenceByAreaId:(NSInteger)areaId
{
    if (![self isCurrentDataBase]) {
        return nil;
    }
    
    __block YLProvence *p = nil;
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql;
            sql = @"SELECT *FROM provence WHERE areaid = ?";
            FMResultSet *rs = [db executeQuery:sql,[NSNumber numberWithInteger:areaId]];
            while ([rs next]) {
                NSString *name = [rs stringForColumn:@"areaname"];
                long long _id = [rs longLongIntForColumn:@"areaid"];
                p = [[YLProvence alloc] init];
                p._id = _id;
                p.pname = name;
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
    return p;
}
-(YLCity*)queryCityByArea:(NSInteger)pid
{
    if (![self isCurrentDataBase]) {
        return nil;
    }
    
    __block  YLCity *c = nil;
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql;
            sql = @"SELECT *FROM city WHERE areaid = ?";
            FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInteger:pid]];
            while ([rs next]) {
                
                c =[[YLCity alloc] init];
                c._id = [rs longLongIntForColumn:@"areaid"];
                c.cname = [rs stringForColumn:@"name"];
                c.super_id = [rs longLongIntForColumn:@"superid"];
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
    return c;
}

-(YLArea*)queryAreaByAreaId:(NSInteger)cid
{
    if (![self isCurrentDataBase]) {
        return nil;
    }
    
    __block YLArea *c = nil;
    [self.dataBaseQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSString *sql;
            sql = @"SELECT *FROM area WHERE areaid = ?";
            FMResultSet *rs = [db executeQuery:sql, [NSNumber numberWithInteger:cid]];
            while ([rs next]) {
                
                c = [[YLArea alloc] init];
                c._id = [rs longLongIntForColumn:@"areaid"];
                c.aname = [rs stringForColumn:@"areaname"];
                c.super_id = [rs longLongIntForColumn:@"superid"];
            }
        }else{
            NSLog(@"打开数据库失败");
        }
    }];
    return c;
}
@end
