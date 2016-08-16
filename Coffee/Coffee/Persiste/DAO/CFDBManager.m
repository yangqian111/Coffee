//
//  HSDBManager.m
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "CFDBManager.h"
#import "FMDB.h"
#import "HSSql.h"
#import "HSFileManager.h"
#import "NSArray+HSEx.h"
#import "FMResultSet+HSResultSet.h"
#if FMDB_SQLITE_STANDALONE
#import <sqlite3/sqlite3.h>
#else
#import <sqlite3.h>
#endif


@interface CFDBManager ()

@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@end


@implementation CFDBManager

+(CFDBManager *)manager {
    static dispatch_once_t pred;
    static CFDBManager *__manager = nil;
    
    dispatch_once(&pred, ^{
        __manager = [[CFDBManager alloc] init];
    });
    return __manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)dealloc
{
    [self close];
}

- (void)open {
    NSString *userDBPath = [HSFileManager userDBPath];
    if (userDBPath)
    {
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:userDBPath flags:SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE];
        if (queue)
        {
            self.dbQueue = queue;
            
            //back up db
            if ([[NSFileManager defaultManager] fileExistsAtPath:userDBPath])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSString *dbBackupPath = [HSFileManager userDBBackupPath];
                    [[NSFileManager defaultManager] removeItemAtPath:dbBackupPath error:nil];
                    [[NSFileManager defaultManager] copyItemAtPath:userDBPath toPath:dbBackupPath error:nil];
                });
            }
        }
        else
        {
            //record error
            if ([[NSFileManager defaultManager] fileExistsAtPath:userDBPath])
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSString *dbErrorPath = [HSFileManager userDBErrorPath];
                    [[NSFileManager defaultManager] removeItemAtPath:dbErrorPath error:nil];
                    [[NSFileManager defaultManager] copyItemAtPath:userDBPath toPath:dbErrorPath error:nil];
                });
            }
        }
        
        NSString *createTableSql = [HSSql sqlForCurrentUserCreateTable];
        if (createTableSql)
        {
            [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                BOOL success = [db executeStatements:createTableSql];
                if(!success)
                {
			                 NSLog(@"创建表失败");
                }
                db.shouldCacheStatements = YES;
            }];
        }
    }
    
}

-(void)close {
    [self.dbQueue close];
}

#pragma mark - user
-(void)addCurrentUser:(NSString *)userName password:(NSString *)password finished:(void (^)(BOOL))finishBlock {
    if (userName.length == 0 || password.length == 0) {
        [EXCallbackHandle callBackSuccess:finishBlock success:YES];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *userNameCopy = [userName copy];
        NSString *passwordCopy = [password copy];
        __block BOOL success = NO;
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [HSSql sqlForAddUser];
            
            [db executeUpdate:sql,userNameCopy,passwordCopy];
            
            success = ![db hadError];
        }];
        [EXCallbackHandle callBackSuccess:finishBlock success:success];
    });
}


- (void)getUsersWithName:(NSString *)userName password:(NSString *)password finished:(void (^)(BOOL, NSArray *))finishBlock {
    if (!finishBlock) {
        return;
    }
    
    if (userName.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *users = [self doGetUsersByUserName:userName password:password];
        [EXCallbackHandle callBackSuccessAndArray:finishBlock success:users != nil array:users];
    });
    
}

- (NSArray *)doGetUsersByUserName:(NSString *)userName password:(NSString *)password {
    __block NSMutableArray *users = [NSMutableArray array];
    __block BOOL success = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [HSSql sqlForGetUser];
        FMResultSet *result = [db executeQuery:sql,userName,password];
        NSArray *userDicArray = [result resultArray];
        for (NSDictionary *userDic in userDicArray)
        {
            [users addObject:userDic];
        }
        success = ![db hadError];
    }];
    return (success ? users : nil);
}

#pragma mark - addCoffee
- (void)addCoffee:(NSArray *)coffees finish:(void (^)(BOOL))finishBlock {
    if (coffees.count==0) {
        [EXCallbackHandle callBackSuccess:finishBlock success:YES];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *coffeesCopy = [coffees copy];
        __block BOOL success = NO;
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            for (CFCoffeeModel *model in coffeesCopy) {
                NSString *sql = [HSSql sqlForAddCoffee];
                [db executeUpdate:sql,model.coffeeId,@(model.index),model.name,model.avatarURL,model.price,model.country,model.productArea,model.heightLevel,model.level,model.flavorDesc,model.flavorDescURL,model.desc,model.videoURL];
            }
            success = ![db hadError];
        }];
        [EXCallbackHandle callBackSuccess:finishBlock success:success];
    });
}

- (void)getAllCoffee:(void (^)(BOOL, NSArray *))finishBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        __block NSMutableArray *coffees = [NSMutableArray array];
        __block BOOL success = NO;
        [self.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *sql = [HSSql sqlForGetAllCoffee];
            FMResultSet *result = [db executeQuery:sql];
            NSArray *coffeeDicArray = [result resultArray];
            for (NSDictionary *coffeeDic in coffeeDicArray)
            {
                CFCoffeeModel *model = [[CFCoffeeModel alloc] initWithDictionary:coffeeDic];
                [coffees addObject:model];
            }
            success = ![db hadError];
        }];
        [EXCallbackHandle callBackSuccessAndArray:finishBlock success:coffees != nil array:coffees];
    });
}

- (void)updateCoffee:(NSArray *)coffees finish:(void (^)(BOOL))finishBlock {
    if (coffees.count==0) {
        [EXCallbackHandle callBackSuccess:finishBlock success:YES];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *coffeesCopy = [coffees copy];
        __block BOOL success = NO;
        [self.dbQueue inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [HSSql sqlForUpdateCoffee];
            for (CFCoffeeModel *model in coffeesCopy) {
                if ([model isKindOfClass:[CFCoffeeModel class]]) {
                    [db executeUpdate:sql,@(model.index),model.name,model.avatarURL,model.price,model.country,model.productArea,model.heightLevel,model.level,model.flavorDesc,model.flavorDescURL,model.desc,model.videoURL,model.coffeeId];
                }
            }
            success = ![db hadError];
        }];
        [EXCallbackHandle callBackSuccess:finishBlock success:success];
    });
}

-(void)deleteCoffee:(NSString *)coffeeId finish:(void (^)(BOOL))finishBlock {
    if (coffeeId.length == 0) {
        [EXCallbackHandle callBackSuccess:finishBlock success:YES];
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        __block BOOL success = NO;
        NSString *coffeeIdCopy = [coffeeId copy];
        [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            NSString *sql = [HSSql sqlForDeleteCoffee];
            [db executeUpdate: sql,coffeeIdCopy];
            success = ![db hadError];
        }];
        [EXCallbackHandle callBackSuccess:finishBlock success:success];
    });
    
}

@end
