//
//  HSFileManager.m
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "HSFileManager.h"

@implementation HSFileManager

+ (void)load
{
    __block id observer =
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIApplicationDidFinishLaunchingNotification
     object:nil
     queue:nil
     usingBlock:^(NSNotification *note) {
         [self setup];
         [[NSNotificationCenter defaultCenter] removeObserver:observer];
     }];
}

+ (void)setup
{
    [[self manager] start];
}

#pragma mark - init & dealloc
+ (HSFileManager *)manager
{
    static dispatch_once_t pred;
    static HSFileManager *__manager = nil;
    
    dispatch_once(&pred, ^{
        __manager = [[HSFileManager alloc] init];
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
    
}

#pragma mark - private
- (void)start
{
    //创建需要的目录
    [[self class] hsRootDirectory];
    [[self class] dbDirectory];
}

#pragma mark - public
+ (NSString *)hsRootDirectory
{
    //app数据根目录
    NSString *rootDir = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"CFData"];
    BOOL isDir = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:rootDir isDirectory:&isDir];
    if(!exist && !isDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:rootDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return rootDir;
}

+ (NSString *)dbDirectory
{
    NSString *dbDirectory = [[self hsRootDirectory] stringByAppendingPathComponent:@"Storage"];
    BOOL isDir = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dbDirectory isDirectory:&isDir];
    if(!exist && !isDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dbDirectory;
}

+ (NSString *)currentUserDBDirectory
{
    
    NSString *dbDirectory = [[self dbDirectory] stringByAppendingPathComponent:@"CFUserDB"];
    BOOL isDir = NO;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:dbDirectory isDirectory:&isDir];
    if(!exist && !isDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return dbDirectory;
    
}


+(NSString *)userDBPath {
    NSString *dbDirectory = [self currentUserDBDirectory];
    if (dbDirectory)
    {
        NSString *dbPath = [dbDirectory stringByAppendingPathComponent:@"storage.sqlite3"];
        return dbPath;
    }
    else
    {
        return nil;
    }
}

+ (NSString *)userDBBackupPath
{
    NSString *dbDirectory = [self currentUserDBDirectory];
    if (dbDirectory)
    {
        NSString *dbPath = [dbDirectory stringByAppendingPathComponent:@"storage.backup"];
        return dbPath;
    }
    else
    {
        return nil;
    }
}

+ (NSString *)userDBErrorPath
{
    NSString *dbDirectory = [self currentUserDBDirectory];
    if (dbDirectory)
    {
        NSString *dbPath = [dbDirectory stringByAppendingPathComponent:@"storage.error"];
        return dbPath;
    }
    else
    {
        return nil;
    }
}

@end
