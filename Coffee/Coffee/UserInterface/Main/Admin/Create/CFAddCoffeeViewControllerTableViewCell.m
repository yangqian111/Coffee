//
//  CFAddCoffeeViewControllerTableViewCell.m
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewControllerTableViewCell.h"
#import "CFAvatarCropViewController.h"

@interface CFAddCoffeeViewControllerTableViewCell ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIPopoverController *popover;
@property (nonatomic,copy) NSString *avatarURL;

@end

@implementation CFAddCoffeeViewControllerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *icon = [UIImageView new];
        [self.contentView addSubview:icon];
        icon.image = [UIImage imageNamed:@"icon"];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).mas_offset(40);
            make.width.mas_equalTo(240);
            make.height.mas_equalTo(125);
        }];
        
        UIButton *addAvatar = [UIButton new];
        addAvatar.layer.cornerRadius = 65;
        addAvatar.layer.masksToBounds = YES;
        [addAvatar addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [addAvatar setBackgroundImage:[UIImage imageNamed:@"default_image"] forState:UIControlStateNormal];
        [self.contentView addSubview:addAvatar];
        self.avatarImage = addAvatar;
        [addAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(icon.mas_left).mas_offset(-30);
            make.width.height.mas_equalTo(130);
            make.top.mas_equalTo(icon.mas_bottom).mas_offset(60);
        }];
        
        UILabel *nameLabel = [UILabel new];
        [self.contentView addSubview:nameLabel];
        nameLabel.text = @"名称:";
        nameLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextField *name = [UITextField new];
        name.delegate = self;
        name.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
        name.leftViewMode = UITextFieldViewModeAlways;
        name.background = [UIImage imageNamed:@"short_biankuang"];
        name.textColor = [UIColor blackColor];
        [self.contentView addSubview:name];
        self.name = name;
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel.mas_right).mas_offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(addAvatar).mas_offset(-40);
        }];
        
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(icon.mas_left);
            make.centerY.mas_equalTo(self.name);
        }];
        
        UILabel *priceLabel = [UILabel new];
        [self.contentView addSubview:priceLabel];
        priceLabel.text = @"价格:";
        priceLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextField *price = [UITextField new];
        price.delegate = self;
        price.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
        price.leftViewMode = UITextFieldViewModeAlways;
        price.background = [UIImage imageNamed:@"short_biankuang"];
        price.textColor = [UIColor blackColor];
        [self.contentView addSubview:price];
        self.price = price;
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceLabel.mas_right).mas_offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(name);
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(name.mas_right).mas_offset(25);
            make.centerY.mas_equalTo(self.name);
        }];
        
        UITextView *properties = [UITextView new];
        properties.delegate = self;
        properties.textColor = [UIColor colorWithHexString:@"5e544a"];
        properties.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        
        properties.layer.contents = (id)[UIImage imageNamed:@"biankuang3"].CGImage;
        [self.contentView addSubview:properties];
        self.properties = properties;
        [properties mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel);
            make.top.mas_equalTo(name.mas_bottom).mas_offset(5);
            make.right.mas_equalTo(price.mas_right);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-5);
            make.height.mas_equalTo(150);
        }];
        
    }
    return self;
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
    popover.passthroughViews = @[self.avatarImage];
    [popover presentPopoverFromRect:self.avatarImage.bounds inView:self.avatarImage permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"出来了");
    UIImage *orgImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *compressImage = [[UIImage imageWithData:UIImageJPEGRepresentation([UIImage scaleAndRotateImage:orgImage], 0.5)] copy];
    [self.avatarImage setImage:compressImage forState:UIControlStateNormal];
    NSString *cacheImageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
    self.avatarURL = cacheImageUUID;
    [[SDWebImageManager sharedManager] saveImageToCache:compressImage forURL:[NSURL URLWithString:self.avatarURL]];
    if ([self.delegate respondsToSelector:@selector(finishEdit:price:properties:headImageURL:)]) {
        [self.delegate finishEdit:_name.text price:_price.text properties:_properties.text headImageURL:self.avatarURL];
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
    if ([self.delegate respondsToSelector:@selector(finishEdit:price:properties:headImageURL:)]) {
        [self.delegate finishEdit:_name.text price:_price.text properties:_properties.text headImageURL:self.avatarURL];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(finishEdit:price:properties:headImageURL:)]) {
        [self.delegate finishEdit:_name.text price:_price.text properties:_properties.text headImageURL:self.avatarURL];
    }
}
@end
