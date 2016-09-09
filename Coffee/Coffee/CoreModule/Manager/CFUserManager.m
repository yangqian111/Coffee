//
//  CFUserManager.m
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFUserManager.h"

@implementation CFUserManager

+(CFUserManager *)manager {
    static dispatch_once_t pred;
    static CFUserManager *__manager = nil;
    
    dispatch_once(&pred, ^{
        __manager = [[CFUserManager alloc] init];
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

- (void)initCurrentUser:(NSString *)userName {
    [[NSUserDefaults standardUserDefaults] setObject:userName forKey:@"currentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeCurrentUser {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [EXCallbackHandle notify:@"CFLoginStatusChanged"];
}

- (BOOL)isCurrentAdmin {
    NSString *name = [[NSUserDefaults standardUserDefaults] valueForKey:@"currentUser"];
    if (name) {
        return [name isEqualToString:@"admin"];
    }
    return NO;
}

- (NSString *)firstTitle {
    NSString *firstTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"firstTitle"];
    if (firstTitle.length>0) {
        return firstTitle;
    }
    return @"Enjoy coffee time";
}

-(NSString *)secondTitle {
    NSString *secondTitle = [[NSUserDefaults standardUserDefaults] valueForKey:@"secondTitle"];
    if (secondTitle.length>0) {
        return secondTitle;
    }
    return @"Choose your coffee";
}

-(void)setFirstTitle:(NSString *)firstTitle {
    [[NSUserDefaults standardUserDefaults] setObject:firstTitle forKey:@"firstTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setSecondTitle:(NSString *)secondTitle {
    [[NSUserDefaults standardUserDefaults] setObject:secondTitle forKey:@"secondTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
