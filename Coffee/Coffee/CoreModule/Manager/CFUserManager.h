//
//  CFUserManager.h
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFUserManager : NSObject

+(CFUserManager *)manager;

- (void)initCurrentUser:(NSString *)userName;

- (BOOL)isCurrentAdmin;//当前用户是否是管理员

- (void)removeCurrentUser;

- (NSString *)firstTitle;

- (NSString *)secondTitle;

- (void)setFirstTitle:(NSString *)firstTitle;

- (void)setSecondTitle:(NSString *)secondTitle;

@end
