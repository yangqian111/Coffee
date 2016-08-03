//
//  CFAvatarCropViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAvatarCropViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@implementation CFAvatarCropViewController


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.allowsEditing = YES;
        self.mediaTypes = @[(id)kUTTypeImage];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
    self.mediaTypes = mediaTypes;
    self.allowsEditing = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
