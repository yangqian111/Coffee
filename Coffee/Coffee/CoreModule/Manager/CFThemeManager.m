//
//  CFThemeManager.m
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFThemeManager.h"

@implementation CFThemeManager

+(CFThemeManager *)manager {
    static dispatch_once_t pred;
    static CFThemeManager *__manager = nil;
    
    dispatch_once(&pred, ^{
        __manager = [[CFThemeManager alloc] init];
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

- (void)setCurrentBKImage:(NSString *)imageName {
    [[NSUserDefaults standardUserDefaults] setObject:imageName forKey:@"BKImage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(UIImage *)currentBKImage {
    NSString *imageName = [[NSUserDefaults standardUserDefaults] objectForKey:@"BKImage"];
    UIImage *BKImage = [UIImage imageWithContentsOfFile:imageName];
    if (BKImage) {
        return BKImage;
    }else{
        NSString *defaultBKPath = [[NSBundle mainBundle] pathForResource:@"Images/default" ofType:@"jpg"];
        return [UIImage imageWithContentsOfFile:defaultBKPath];
    }
    return nil;
}

@end
