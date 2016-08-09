//
//  CFCoffeeListModel.m
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFCoffeeModel.h"

//@property (nonatomic,readonly,copy) NSString*videoURL;//视频地址

@implementation CFCoffeeModel

- (instancetype)initWithDictionary:(NSDictionary *)modelDic {
    self = [super init];
    NSDictionary *dicCopy = [modelDic copy];
    if (self) {
        _coffeeId = [dicCopy[@"coffeeId"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"coffeeId"];
        _name = [dicCopy[@"name"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"name"];
        _price = [dicCopy[@"price"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"price"];
        _avatarURL = [dicCopy[@"avatarURL"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"avatarURL"];
        _index = [dicCopy[@"index"] intValue];
        _country = [dicCopy[@"country"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"country"];
        _productArea = [dicCopy[@"productArea"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"productArea"];
        _level = [dicCopy[@"level"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"level"];
        _heightLevel = [dicCopy[@"heightLevel"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"heightLevel"];
        _flavorDesc = [dicCopy[@"flavorDesc"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"flavorDesc"];
        _flavorDescURL = [dicCopy[@"flavorDescURL"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"flavorDescURL"];
        _desc = [dicCopy[@"desc"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"desc"];
    }
    return self;
}

@end
