//
//  EXCallbackHandle.h
//  项目基础框架
//
//  Created by 羊谦 on 16/7/6.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EXCallbackHandle : NSObject
+ (void)notify:(NSString *)notification;
+ (void)notify:(NSString *)notification userInfo:(NSDictionary *)userInfo;
+ (void)notify:(NSString *)notification object:(id)object userInfo:(NSDictionary *)userInfo;
+ (void)callBackSuccess:(void (^)(BOOL))block success:(BOOL)success;
+ (void)callBackSuccessAndArray:(void (^)(BOOL,NSArray *))block success:(BOOL)success array:(NSArray *)array;
+ (void)callBackObject:(void (^)(id))block object:(id)object;
+ (void)callBackObjectEnum:(void (^)(id,NSUInteger))block object:(id)object enumValue:(NSUInteger)enumValue;
+ (void)callBackEnum:(void (^)(NSUInteger))block enumValue:(NSUInteger)enumValue;
+ (void)callBackArray:(void (^)(NSArray *))block array:(NSArray *)array;
+ (void)callBackSuccessAndObject:(void (^)(BOOL,id))block success:(BOOL)success object:(id)object;
+ (void)callBackSuccessAndCount:(void (^)(BOOL,NSUInteger))block success:(BOOL)success count:(NSUInteger)count;
+ (void)callBackSuccessAndTwoCounts:(void (^)(BOOL,NSUInteger,NSUInteger))block success:(BOOL)success count1:(NSUInteger)count1 count2:(NSUInteger)count2;
@end
