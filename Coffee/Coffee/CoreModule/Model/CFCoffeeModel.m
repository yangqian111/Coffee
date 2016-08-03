//
//  CFCoffeeListModel.m
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFCoffeeModel.h"

@implementation CFCoffeeModel

- (instancetype)initWithDictionary:(NSDictionary *)modelDic {
    self = [super init];
    NSDictionary *dicCopy = [modelDic copy];
    if (self) {
        _coffeeId = dicCopy[@"coffeeId"];
        _name = dicCopy[@"name"];
        _price = dicCopy[@"price"];
        _avatarURL = dicCopy[@"avatarURL"];
        _index = [dicCopy[@"index"] intValue];
    }
    return self;
}

@end
