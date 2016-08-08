//
//  CFLoginManager.m
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFLoginManager.h"
#import "CFUserManager.h"

@implementation CFLoginManager

+(CFLoginManager *)manager {
    static dispatch_once_t pred;
    static CFLoginManager *__manager = nil;
    
    dispatch_once(&pred, ^{
        __manager = [[CFLoginManager alloc] init];
    });
    return __manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)login:(NSString *)userName password:(NSString *)password finish:(void (^)(BOOL))finishBlock {
    [CFDB getUsersWithName:userName password:password finished:^(BOOL success, NSArray *user) {
        if (success&&user.count>0) {
            NSDictionary *dic = user[0];
            NSString *userName = dic[@"userName"];
            [[CFUserManager manager] initCurrentUser:userName];
            [EXCallbackHandle notify:@"CFUserChanged"];
        }
    }];
}

- (void)logout {
    [[CFUserManager manager] removeCurrentUser];
}

- (BOOL)isLogin {
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    if (userName.length == 0 || userName == nil) {
        return NO;
    }else{
        return YES;
    }
}

@end
