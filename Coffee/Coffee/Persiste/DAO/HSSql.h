//
//  HSSql.h
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSSql : NSObject

+ (NSString *)sqlForCurrentUserCreateTable;


//用户操作
+ (NSString *)sqlForGetUser;
+ (NSString *)sqlForAddUser;

//咖啡列表操作
+ (NSString *)sqlForAddCoffee;
+ (NSString *)sqlForGetCoffee;
+ (NSString *)sqlForUpdateCoffee;
+ (NSString *)sqlForGetAllCoffee;
+ (NSString *)sqlForDeleteCoffee;
@end
