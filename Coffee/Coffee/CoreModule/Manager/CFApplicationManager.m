//
//  CFApplicationManager.m
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFApplicationManager.h"

@implementation CFApplicationManager

+(void)applicationConfigInit {
    [self initNavigationBar];
    [self initDB];//初始化数据库
}

+ (void)initNavigationBar {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    //    [UINavigationBar appearance].barTintColor = [UIColor lightGrayColor];
    //    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].translucent = YES;
//    NSDictionary *attributes = @{
//                                 NSFontAttributeName:[UIFont systemFontOfSize:19],
//                                 NSForegroundColorAttributeName: [UIColor whiteColor]
//                                 };
//    [UINavigationBar appearance].titleTextAttributes = attributes;
}

+ (void)initDB {
    [CFDB open];
    BOOL hasLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunch"];
    if (!hasLaunch) {
        [CFDB addCurrentUser:@"admin" password:@"admin" finished:^(BOOL success) {
            if (success) {
                NSLog(@"插入管理员用户成功");
                [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"hasLaunch"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                NSLog(@"插入管理员用户成功");
            }
        }];
        
        [CFDB addCurrentUser:@"user" password:@"user" finished:^(BOOL success) {
            if (success) {
                NSLog(@"插入普通用户成功");
                [[NSUserDefaults standardUserDefaults] setBool: YES forKey: @"hasLaunch"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                NSLog(@"插入普通用户成功");
            }
        }];
    }
}

@end
