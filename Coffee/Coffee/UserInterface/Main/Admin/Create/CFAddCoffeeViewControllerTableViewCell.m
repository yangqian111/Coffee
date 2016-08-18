//
//  CFAddCoffeeViewControllerTableViewCell.m
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewControllerTableViewCell.h"
#import "CFAvatarCropViewController.h"

@interface CFAddCoffeeViewControllerTableViewCell ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIPopoverController *popover;


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
            make.top.mas_equalTo(self.contentView).mas_offset(60);
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
            make.top.mas_equalTo(icon.mas_bottom).mas_offset(40);
        }];
        
        UILabel *nameLabel = [UILabel new];
        [self.contentView addSubview:nameLabel];
        nameLabel.text = @"名称:";
        nameLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextField *name = [UITextField new];
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
            make.top.mas_equalTo(addAvatar);
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
            make.top.mas_equalTo(addAvatar);
        }];
        
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(name.mas_right).mas_offset(25);
            make.centerY.mas_equalTo(self.name);
        }];
        
        UILabel *countryLabel = [UILabel new];
        [self.contentView addSubview:countryLabel];
        countryLabel.text = @"国家:";
        countryLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        countryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextField *country = [UITextField new];
        country.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
        country.leftViewMode = UITextFieldViewModeAlways;
        country.background = [UIImage imageNamed:@"short_biankuang"];
        country.textColor = [UIColor blackColor];
        [self.contentView addSubview:country];
        self.country = country;
        [country mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(countryLabel.mas_right).mas_offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(name.mas_bottom).mas_offset(10);
        }];
        
        [countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel);
            make.centerY.mas_equalTo(self.country);
        }];
        
        UILabel *levelLabel = [UILabel new];
        [self.contentView addSubview:levelLabel];
        levelLabel.text = @"等级:";
        levelLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        levelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextField *level = [UITextField new];
        level.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
        level.leftViewMode = UITextFieldViewModeAlways;
        level.background = [UIImage imageNamed:@"short_biankuang"];
        level.textColor = [UIColor blackColor];
        [self.contentView addSubview:level];
        self.level = level;
        [level mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(priceLabel.mas_right).mas_offset(5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(country);
        }];
        
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(country.mas_right).mas_offset(25);
            make.centerY.mas_equalTo(self.country);
        }];
        
        UILabel *productAreaLabel = [UILabel new];
        [self.contentView addSubview:productAreaLabel];
        productAreaLabel.text = @"产地:";
        productAreaLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        productAreaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextField *productArea = [UITextField new];
        productArea.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
        productArea.leftViewMode = UITextFieldViewModeAlways;
        productArea.background = [UIImage imageNamed:@"medim_biankuang"];
        productArea.textColor = [UIColor blackColor];
        [self.contentView addSubview:productArea];
        self.productArea = productArea;
        [productArea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(productAreaLabel.mas_right).mas_offset(5);
            make.width.mas_equalTo(370);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(country.mas_bottom).mas_offset(10);
        }];
        
        [productAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel);
            make.centerY.mas_equalTo(self.productArea);
        }];
        
        UILabel *heightLevelLabel = [UILabel new];
        [self.contentView addSubview:heightLevelLabel];
        heightLevelLabel.text = @"海拔:";
        heightLevelLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        heightLevelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextField *heightLevel = [UITextField new];
        heightLevel.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
        heightLevel.leftViewMode = UITextFieldViewModeAlways;
        heightLevel.background = [UIImage imageNamed:@"medim_biankuang"];
        heightLevel.textColor = [UIColor blackColor];
        [self.contentView addSubview:heightLevel];
        self.heightLevel = heightLevel;
        [heightLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(heightLevelLabel.mas_right).mas_offset(5);
            make.width.mas_equalTo(370);
            make.height.mas_equalTo(35);
            make.top.mas_equalTo(productArea.mas_bottom).mas_offset(10);
        }];
        
        [heightLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameLabel);
            make.centerY.mas_equalTo(self.heightLevel);
        }];
        
        UILabel *flavorDescLabel = [UILabel new];
        [self.contentView addSubview:flavorDescLabel];
        flavorDescLabel.text = @"风味描述:";
        flavorDescLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        flavorDescLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        
        UITextView *flavorDesc = [UITextView new];
        flavorDesc.font = [UIFont systemFontOfSize:18];
        flavorDesc.layer.contents = (id)[UIImage imageNamed:@"biankuang3"].CGImage;
        flavorDesc.textColor = [UIColor blackColor];
        [self.contentView addSubview:flavorDesc];
        self.flavorDesc = flavorDesc;
        [flavorDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(flavorDescLabel.mas_right).mas_offset(5);
            make.width.mas_equalTo(495);
            make.height.mas_equalTo(70);
            make.top.mas_equalTo(heightLevel.mas_bottom).mas_offset(10);
        }];
        
        [flavorDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addAvatar);
            make.centerY.mas_equalTo(self.flavorDesc);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-40);
        }];
        
        //        UIImageView *flavorDescImageView =  [UIImageView new];
        //        flavorDescImageView.image = [UIImage imageNamed:@"flavorDescImage"];
        //        [self.contentView addSubview:flavorDescImageView];
        //        self.flavorDescImageView = flavorDescImageView;
        //        [flavorDescImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerX.mas_equalTo(self.contentView);
        //            make.bottom.mas_equalTo(self.contentView).mas_offset(-40);
        //            make.width.mas_equalTo(240);
        //            make.top.mas_equalTo(flavorDesc.mas_bottom).mas_offset(20);
        //        }];
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
    UIImage *compressImage = [[UIImage imageWithData:UIImageJPEGRepresentation([UIImage scaleAndRotateImage:orgImage], 0.1)] copy];
    self.avatarImageCache = compressImage;
    [self.avatarImage setImage:self.avatarImageCache forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消了");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}



@end
