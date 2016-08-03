//
//  CFCoffeeListModel.h
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFCoffeeModel : NSObject

@property (nonatomic,readonly,copy) NSString *coffeeId;//id
@property (nonatomic,assign) NSUInteger index;//排序
@property (nonatomic,readonly,copy) NSString *name;//名称
@property (nonatomic,readonly,copy) NSString *price;//价格
@property (nonatomic,readonly,copy) NSString *avatarURL;//头像地址
@property (nonatomic,readonly,copy) NSString *country;//国家
@property (nonatomic,readonly,copy) NSString *productArea;//生产地址
@property (nonatomic,readonly,copy) NSString *heightLevel;//海拔
@property (nonatomic,readonly,copy) NSString *level;//等级
@property (nonatomic,readonly,copy) NSString *flavorDesc;//风味描述
@property (nonatomic,readonly,copy) NSString *flavorDescURL;//风味描述图片
@property (nonatomic,readonly,copy) NSString *desc;//简介
@property (nonatomic,readonly,copy) NSString*videoURL;//视频地址

- (instancetype)initWithDictionary:(NSDictionary *)modelDic;

@end
