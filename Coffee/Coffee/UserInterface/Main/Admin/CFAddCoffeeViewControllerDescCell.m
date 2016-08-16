//
//  CFAddCoffeeViewControllerDescCell.m
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewControllerDescCell.h"
#import "CFAvatarCropViewController.h"

@interface CFAddCoffeeViewControllerDescCell ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>

@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,weak) HSTextView *desc;//简述
@property (nonatomic,weak) UIButton *descImageView;//简述图

@end

@implementation CFAddCoffeeViewControllerDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        HSTextView *desc = [HSTextView new];
        desc.delegate = self;
        desc.placeholder = @"简介";
        desc.font = [UIFont systemFontOfSize:18];
        desc.layer.contents = (id)[UIImage imageNamed:@"biankuang3"].CGImage;
        desc.textColor = [UIColor blackColor];
        [self.contentView addSubview:desc];
        self.desc = desc;
        [desc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(240);
            make.width.mas_equalTo(550);
            make.height.mas_equalTo(100);
            make.top.mas_equalTo(10);
        }];
        
        UIButton *descImageView = [UIButton new];
        descImageView.imageView.contentMode = UIViewContentModeScaleAspectFill;
        descImageView.layer.masksToBounds = YES;
        [descImageView addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [descImageView setTitle:@"添加图片(图片尺寸建议：1095 * 305)" forState:UIControlStateNormal];
        descImageView.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
        [descImageView setTitleColor:[UIColor colorWithHexString:@"614A3D"] forState:UIControlStateNormal];
        descImageView.titleLabel.textAlignment = NSTextAlignmentCenter;
        [descImageView setBackgroundImage:[UIImage imageNamed:@"kuang8"] forState:UIControlStateNormal];
        [self.contentView addSubview:descImageView];
        self.descImageView = descImageView;
        [descImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(desc.mas_bottom).mas_offset(5);
            make.left.mas_equalTo(desc.mas_left);
            make.right.mas_equalTo(desc.mas_right);
            make.height.mas_equalTo(200);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        }];
    }
    return self;
}

-(void)configCell:(NSDictionary *)dic {
    NSDictionary *dicCopy = [dic copy];
    NSString *text = dicCopy[@"text"];
    if (text.length>0) {
        _desc.text = text;
    }else{
        _desc.text = @"";
    }
    UIImage *image = dicCopy[@"image"];
    if (image) {
        [_descImageView setTitle:@"" forState:UIControlStateNormal];
        [_descImageView setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        [_descImageView setBackgroundImage:[UIImage imageNamed:@"kuang8"] forState:UIControlStateNormal];
        [_descImageView setTitle:@"添加图片(图片尺寸建议：1095 * 305)" forState:UIControlStateNormal];
    }
}

- (void)choosePhoto:(UIButton *)sender {
    [self.superview.superview endEditing:YES];
    CFAvatarCropViewController *imagePicker = [[CFAvatarCropViewController alloc] init];
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    imagePicker.delegate = self;
    imagePicker.view.backgroundColor = [UIColor clearColor];
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
    self.popover = popover;
    popover.passthroughViews = @[self.descImageView];
    [popover presentPopoverFromRect:self.descImageView.bounds inView:self.descImageView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"出来了");
    UIImage *orgImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *compressImage = [[UIImage imageWithData:UIImageJPEGRepresentation([UIImage scaleAndRotateImage:orgImage], 0.5)] copy];
    [self.descImageView setBackgroundImage:compressImage forState:UIControlStateNormal];
    [_descImageView setTitle:@"" forState:UIControlStateNormal];
    if ([self.cellDelegate respondsToSelector:@selector(finishDescImage:index:)]) {
        [self.cellDelegate finishDescImage:compressImage index:self.index];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消了");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([self.cellDelegate respondsToSelector: @selector(finishDescText:index:)]) {
        [self.cellDelegate finishDescText:textView.text index:self.index];
    }
}

@end
