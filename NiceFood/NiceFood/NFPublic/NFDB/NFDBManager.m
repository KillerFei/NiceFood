//
//  NFDBManager.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/20.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFDBManager.h"

@interface NFDBManager ()

@property (nonatomic, strong) FMDatabaseQueue *cacheDBQueque;
@end

static NSString *const cacheDBPath                = @"nfCache.db";

@implementation NFDBManager

+ (instancetype)shareInstance
{
    static NFDBManager *dbManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dbManger = [[NFDBManager alloc] init];
    });
    return dbManger;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configDB];
    }
    return self;
}
- (void)configDB
{
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *dbDir       = [libraryPath stringByAppendingString:@"/DuTou"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbDir]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:dbDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *dbPath      = [dbDir stringByAppendingString:[NSString stringWithFormat:@"/%@", cacheDBPath]];
    _cacheDBQueque = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    if (!_cacheDBQueque) return;
    
    [_cacheDBQueque inDatabase:^(FMDatabase *db) {
        
        NSString *collectTable = @"create table if not exists collectFoods(pageUrl text UNSIGNED NOT NULL PRIMARY KEY, fid integer, title text, descrip text, imgUrl text, joinDate dateTime, reserve text);";
        BOOL collectResult = [db executeUpdate:collectTable];
        if (collectResult) {
            NSLog(@"---------收藏菜单创建成功");
            NSLog(@"---------%@",dbPath);
        }

    }];
}
#pragma mark -------- action
// 保存
- (BOOL)saveFood:(NFBaseModel *)food
{
    __block BOOL reslut = NO;
    NSString *insertSql = @"insert or replace into collectFoods(pageUrl,fid,title,descrip,imgUrl,joinDate,reserve) values(?,?,?,?,?,?,?)";;
    [_cacheDBQueque inDatabase:^(FMDatabase *db) {
        
        reslut = [db executeUpdate:insertSql,food.page_url,food.fid,food.title,food.descrip,food.img_url,[NSDate date],food.reserve];
    }];
    return reslut;
}
// 删除
- (BOOL)deleteFood:(NFBaseModel *)food
{
    __block BOOL reslut = NO;
    NSString *deleteSql = @"delete from collectFoods where pageUrl = ?";
        [_cacheDBQueque inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        reslut = [db executeUpdate:deleteSql,food.page_url];
    }];
    return reslut;
}
// 获取
- (NSArray *)getFoods
{
    NSMutableArray *foods = [NSMutableArray array];
    NSString *selectSql = @"select * from collectFoods order by joinDate desc";
    [_cacheDBQueque inDatabase:^(FMDatabase *db) {
        
        FMResultSet * data = [db executeQuery:selectSql];
        while (data.next) {
            NFBaseModel *food = [[NFBaseModel alloc] init];
            food.page_url    = [data objectForColumnName:@"pageUrl"];
            food.fid         = [data objectForColumnName:@"fid"];
            food.title       = [data objectForColumnName:@"title"];
            food.descrip     = [data objectForColumnName:@"descrip"];
            food.img_url     = [data objectForColumnName:@"imgUrl"];
            food.joinDate    = [data dateForColumn:@"joinDate"];
            food.reserve     = [data objectForColumnName:@"reserve"];
            [foods addObject:food];
        }
        [data close];
    }];
    return foods;
}
+ (void)runBlockInBackground:(void (^)())block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (block)
        {
            block();
        }
    });
}
@end
