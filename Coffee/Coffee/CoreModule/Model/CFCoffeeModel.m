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
        _index = [dicCopy[@"indexCoffee"] intValue];
        _properties = [dicCopy[@"properties"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"properties"];
        _desc = [dicCopy[@"desc"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"desc"];
        _videoURL = [dicCopy[@"videoURL"] isKindOfClass:[NSNull class]] ? nil : dicCopy[@"videoURL"];
    }
    return self;
}

@end
