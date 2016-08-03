//
//  AppDelegate.h
//  项目基础框架
//
//  Created by NetEase on 16/3/10.
//  Copyright © 2016年 NetEase-yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)appDelegate;

//支持旋转
-(void)OrientationMask;

//禁止旋转
-(void)OrientationMaskBack;
@end

