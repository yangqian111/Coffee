//
//  AppDelegate.m
//  项目基础框架
//
//  Created by NetEase on 16/3/10.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import "AppDelegate.h"
#import "CFRootViewController.h"
#import "CFApplicationManager.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@property (nonatomic,assign) BOOL OriFlag;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    CFRootViewController *vc = [[CFRootViewController alloc] init];
    self.window.rootViewController = vc;
    [CFApplicationManager applicationConfigInit];
    [IQKeyboardManager sharedManager].enable = YES;
    [NSThread sleepForTimeInterval: 1.0];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.OriFlag) {
        return UIInterfaceOrientationMaskAll;
    }else{
        return UIInterfaceOrientationMaskLandscapeRight;
    }
}

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)OrientationMask {
    self.OriFlag = YES;
}

-(void)OrientationMaskBack {
    self.OriFlag = NO;
}

@end
