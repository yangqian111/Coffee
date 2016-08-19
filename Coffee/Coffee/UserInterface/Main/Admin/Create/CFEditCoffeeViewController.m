//
//  CFEditCoffeeViewController.m
//  Coffee
//
//  Created by yangqian on 16/8/17.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFEditCoffeeViewController.h"
#import "CFAvatarCropViewController.h"

@interface CFEditCoffeeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak) HSTextView *textView;
@property (nonatomic,weak) UIButton *addImageBtn;
@property (nonatomic,weak) UIButton *cancleBtn;//取消
@property (nonatomic,weak) UIButton *confirmBtn;//保存
@property (nonatomic,strong) UIPopoverController *popover;

@end

@implementation CFEditCoffeeViewController
{
@private
    UIImage *_cacheImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"eaeaea"];
    
    HSTextView *textView = [HSTextView new];
    textView.font = [UIFont systemFontOfSize:16];
    textView.placeholder = @"简介";
    [self.view addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(600);
        make.height.mas_equalTo(100);
        make.top.mas_equalTo(50);
    }];
    self.textView = textView;
    
    UIButton *addImageBtn = [UIButton new];
    [addImageBtn setTitle:@"添加图片(图片尺寸建议：1095 * 305)" forState:UIControlStateNormal];
    addImageBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [addImageBtn setTitleColor:[UIColor colorWithHexString:@"614A3D"] forState:UIControlStateNormal];
    addImageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [addImageBtn setBackgroundImage:[UIImage imageNamed:@"kuang8"] forState:UIControlStateNormal];
    [addImageBtn addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.addImageBtn = addImageBtn;
    [self.view addSubview:addImageBtn];
    [addImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(600);
        make.height.mas_equalTo(150);
        make.top.mas_equalTo(textView.mas_bottom).mas_offset(20);
    }];
    
    UIButton *saveBtn = [UIButton new];
    [saveBtn addTarget:self action:@selector(onDone) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor lightGrayColor]];
    saveBtn.layer.cornerRadius = 10;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview: saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).mas_offset(150);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(addImageBtn.mas_bottom).mas_offset(50);
    }];
    
    UIButton *cancleBtn = [UIButton new];
    [cancleBtn addTarget:self action:@selector(dismissCurrentViewController) forControlEvents:UIControlEventTouchUpInside];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setBackgroundColor:[UIColor lightGrayColor]];
    cancleBtn.layer.cornerRadius = 10;
    cancleBtn.layer.masksToBounds = YES;
    [self.view addSubview: cancleBtn];
    [cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view).mas_offset(-150);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
        make.top.mas_equalTo(addImageBtn.mas_bottom).mas_offset(50);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)choosePhoto:(UIButton *)sender {
    [self.view endEditing:YES];
    CFAvatarCropViewController *imagePicker = [[CFAvatarCropViewController alloc] init];
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    imagePicker.delegate = self;
    imagePicker.view.backgroundColor = [UIColor clearColor];
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
    self.popover = popover;
    popover.passthroughViews = @[self.addImageBtn];
    [popover presentPopoverFromRect:self.addImageBtn.bounds inView:self.addImageBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"出来了");
    UIImage *orgImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *compressImage = [[UIImage imageWithData:UIImageJPEGRepresentation([UIImage scaleAndRotateImage:orgImage], 0.5)] copy];
    _cacheImage = [compressImage copy];
    [self.addImageBtn setBackgroundImage:compressImage forState:UIControlStateNormal];
    [_addImageBtn setTitle:@"" forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消了");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)onDone {
    if ([self.vcDelegate respondsToSelector:@selector(finishTextEdit:)]) {
        [self.vcDelegate finishTextEdit:_textView.text];
    }
    if ([self.vcDelegate respondsToSelector:@selector(finishImagEdit:)]) {
        [self.vcDelegate finishImagEdit:_cacheImage];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
