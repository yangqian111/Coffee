//
//  HSSql.m
//  HotSail
//
//  Created by yangqian on 16/3/28.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import "HSSql.h"

#define kTableUser       @"CFUser"
#define kTableCoffee       @"CFCoffee"


@implementation HSSql

+(NSString *)sqlForCurrentUserCreateTable {
    NSMutableArray *sqlArray = [NSMutableArray array];
    
    //用户表
    NSString *userTableDDL = @"CREATE TABLE IF NOT EXISTS "
    kTableUser "("
    @"usrId INTEGER NOT NULL PRIMARY KEY autoincrement,"
    @"userName VARCHAR(45) NOT NULL,"
    @"password VARCHAR(45) NOT NULL,"
    @"UNIQUE(usrId)"
    @");";
    [sqlArray addObject:userTableDDL];
    
    //咖啡表
    NSString *coffeeDDL = @"CREATE TABLE IF NOT EXISTS "
    kTableCoffee "("
    @"coffeeId VARCHAR(45) NOT NULL PRIMARY KEY,"
    @"indexCoffee INTEGER NOT NULL,"
    @"name VARCHAR(45) NOT NULL,"
    @"avatarURL VARCHAR(255) NULL,"
    @"price VARCHAR(45) NOT NULL,"
    @"country VARCHAR(45)  NULL,"
    @"productArea TEXT NULL,"
    @"heightLevel TEXT NULL,"
    @"level TEXT NULL,"
    @"flavorDesc TEXT NULL,"
    @"flavorDescURL TEXT  NULL,"
    @"desc TEXT NULL,"
    @"videoURL TEXT NULL,"
    @"UNIQUE(coffeeId)"
    @");";
    NSString *coffeeIndexDDL = @"CREATE INDEX IF NOT EXISTS coffee_index_coffeeId ON " kTableCoffee "(coffeeId);";
    [sqlArray addObject:coffeeDDL];
    [sqlArray addObject:coffeeIndexDDL];
    
    
    if (sqlArray.count > 0)
    {
        return [sqlArray componentsJoinedByString:@";"];
    }
    return @"";
}

#pragma mark - user
+(NSString *)sqlForAddUser {
    NSString *sql = @"INSERT OR REPLACE INTO " kTableUser " (userName, password) VALUES (?,?)";
    return sql;
}

+(NSString *)sqlForGetUser {
    NSString *sql = @"SELECT * FROM " kTableUser " WHERE userName = ? AND password = ?";
    return sql;
}

#pragma mark - Coffee
+(NSString *)sqlForAddCoffee {
    NSString *sql = @"INSERT OR REPLACE INTO " kTableCoffee " (coffeeId,indexCoffee,name,avatarURL,price,country,productArea,heightLevel,level,flavorDesc,flavorDescURL,desc,videoURL) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)";
    return sql;
}

+(NSString *)sqlForUpdateCoffee {
    NSString *sql = @"UPDATE OR IGNORE " kTableCoffee " SET indexCoffee = ?, name = ?, avatarURL = ?, price = ?, country = ?, productArea = ?, heightLevel = ?, level = ?,  flavorDesc = ?, flavorDescURL = ?, desc = ?, videoURL = ? WHERE coffeeId = ? ";
    return sql;
}

+(NSString *)sqlForGetCoffee {
    NSString *sql = @"SELECT * FROM " kTableCoffee " WHERE coffeeId = ? ";
    return sql;
}

+(NSString *)sqlForGetAllCoffee {
    NSString *sql = @"SELECT * FROM " kTableCoffee " ORDER BY indexCoffee ASC";
    return sql;
}

+(NSString *)sqlForDeleteCoffee {
    NSString *sql = @"DELETE FROM " kTableCoffee " WHERE coffeeId = ?";
    return sql;
}

@end
