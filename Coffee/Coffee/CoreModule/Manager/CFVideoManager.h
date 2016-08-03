//
//  CFVideoManager.h
//  Coffee
//
//  Created by 羊谦 on 16/7/29.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFVideoManager : NSObject

/**
 *  上传 视频
 *  @name   name    视频名称
 *  @param url         原地址
 *  @param finishBlock 完成上传
 */
- (void)uploadVideo:(NSURL *)url name:(NSString *)name finish:(void (^)(BOOL success,NSString *url,NSData *imageData))finishBlock;

@end
