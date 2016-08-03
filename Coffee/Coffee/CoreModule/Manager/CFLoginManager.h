//
//  CFLoginManager.h
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFLoginManager : NSObject

+(CFLoginManager *)manager;

- (BOOL)isLogin;

- (void)login:(NSString *)userName password:(NSString *)password finish:(void (^)(BOOL isSuccess))finishBlock;

- (void)logout;


@end
