//
//  HSDBManager.h
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CFDB [CFDBManager manager]

@interface CFDBManager : NSObject

+ (CFDBManager *)manager;

- (void)open;
- (void)close;

//user
- (void)addCurrentUser:(NSString *)userName password:(NSString *)password finished:(void (^)(BOOL success))finishBlock;
- (void)getUsersWithName:(NSString *)userName password:(NSString *)password finished:(void (^)(BOOL success,NSArray *user))finishBlock;

//coffee
- (void)addCoffee:(NSArray *)coffees finish:(void (^)(BOOL success))finishBlock;
- (void)getAllCoffee:(void (^)(BOOL succee,NSArray *coffees))finishBlock;
- (void)updateCoffee:(NSArray *)coffees finish:(void (^)(BOOL success))finishBlock;

@end
