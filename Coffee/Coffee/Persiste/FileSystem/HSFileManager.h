//
//  HSFileManager.h
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HSFile [HSFileManager manager]

@interface HSFileManager : NSObject

+ (HSFileManager *)manager;
+ (NSString *)hsRootDirectory;
+ (NSString *)currentUserDBDirectory;

+ (NSString *)userDBPath;
+ (NSString *)userDBBackupPath;
+ (NSString *)userDBErrorPath;

@end
