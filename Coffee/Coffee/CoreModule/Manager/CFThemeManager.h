//
//  CFThemeManager.h
//  Coffee 主题管理类
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFThemeManager : NSObject

+(CFThemeManager *)manager;

- (void)setCurrentBKImage:(NSString *)imageName;

//返回当前的背景图
- (UIImage *)currentBKImage;

@end
