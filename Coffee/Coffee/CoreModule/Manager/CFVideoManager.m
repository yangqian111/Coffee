//
//  CFVideoManager.m
//  Coffee
//
//  Created by 羊谦 on 16/7/29.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFVideoManager.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define KVideoUrlPath   \
[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent: @"VideoURL"]

@interface CFVideoManager ()

@end

@implementation CFVideoManager

+(CFVideoManager *)manager {
    static dispatch_once_t pred;
    static CFVideoManager *__manager = nil;
    
    dispatch_once(&pred, ^{
        __manager = [[CFVideoManager alloc] init];
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


// 将原始视频的URL转化为NSData数据,写入沙盒
- (void)videoWithUrl:(NSURL *)url withFileName:(NSString *)fileName
{
    // 解析一下,为什么视频不像图片一样一次性开辟本身大小的内存写入?
    // 想想,如果1个视频有1G多,难道直接开辟1G多的空间大小来写?
    // 创建存放原始图的文件夹--->VideoURL
    NSFileManager * fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:KVideoUrlPath]) {
        [fileManager createDirectoryAtPath:KVideoUrlPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (url) {
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset) {
                ALAssetRepresentation *rep = [asset defaultRepresentation];
                NSString * videoPath = [KVideoUrlPath stringByAppendingPathComponent:fileName];
                const char *cvideoPath = [videoPath UTF8String];
                FILE *file = fopen(cvideoPath, "a+");
                if (file) {
                    const int bufferSize = 11024 * 1024;
                    // 初始化一个1M的buffer
                    Byte *buffer = (Byte*)malloc(bufferSize);
                    NSUInteger read = 0, offset = 0, written = 0;
                    NSError* err = nil;
                    if (rep.size != 0)
                    {
                        do {
                            read = [rep getBytes:buffer fromOffset:offset length:bufferSize error:&err];
                            written = fwrite(buffer, sizeof(char), read, file);
                            offset += read;
                        } while (read != 0 && !err);//没到结尾，没出错，ok继续
                    }
                    // 释放缓冲区，关闭文件
                    free(buffer);
                    buffer = NULL;
                    fclose(file);
                    file = NULL;
                    
                    // UI的更新记得放在主线程,要不然等子线程排队过来都不知道什么年代了,会很慢的
                    //                    dispatch_async(dispatch_get_main_queue(), ^{
                    //                        NSDictionary *firstDict = [_uploadDataArr firstObject];
                    //                        if(firstDict) {
                    //                            _imgView.image = [UIImage imageWithData:[firstDict objectForKey:@"header"]];
                    //                            _titleLab.text = [firstDict objectForKey:@"name"];
                    //                            _typeLab.text = [firstDict objectForKey:@"type"];
                    //                            NSString *timeStr = [firstDict objectForKey:@"time"];
                    //                            if([timeStr intValue] > 0) {
                    //                                _timeLab.text = [NSString stringWithFormat:@"%@S",timeStr];
                    //                            }
                    //                        }
                    //                    });
                }
            } failureBlock:nil];
        }
    });
}


-(void)uploadVideo:(NSURL *)url name:(NSString *)name finish:(void (^)(BOOL, NSString *, NSData *))finishBlock {
    
}

@end
