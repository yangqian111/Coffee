//
//  CFCoffeeDetailTableViewCell.m
//  Coffee
//
//  Created by 羊谦 on 16/8/9.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFCoffeeDetailTableViewCell.h"


@interface CFCoffeeDetailTableViewCell ()

@property (nonatomic,weak) UIImageView *avatar;
@property (nonatomic,weak) UILabel *name;
@property (nonatomic,weak) UILabel *price;
@property (nonatomic,weak) UILabel *country;
@property (nonatomic,weak) UILabel *level;
@property (nonatomic,weak) UILabel *productArea;
@property (nonatomic,weak) UILabel *heightLevel;
@property (nonatomic,weak) UILabel *flavorDesc;
@property (nonatomic,weak) UIImageView *flavorImageView;

@end

@implementation CFCoffeeDetailTableViewCell

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
        
        UIImageView *addAvatar = [UIImageView new];
        addAvatar.backgroundColor = [UIColor whiteColor];
        addAvatar.image =[UIImage imageNamed:@"default_coffee"];
        addAvatar.layer.cornerRadius = 65;
        addAvatar.layer.masksToBounds = YES;
        self.avatar = addAvatar;
        [self.contentView addSubview:addAvatar];
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
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(addAvatar).mas_offset(5);
            make.left.mas_equalTo(icon.mas_left);
        }];
        
        UILabel *name = [UILabel new];
        [self.contentView addSubview:name];
        self.name = name;
        
        UILabel *priceLabel = [UILabel new];
        [self.contentView addSubview:priceLabel];
        priceLabel.text = @"价格:";
        priceLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel);
            make.left.mas_equalTo(icon.mas_right);
        }];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel);
            make.left.mas_equalTo(nameLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(150);
        }];
        
        UILabel *price = [UILabel new];
        [self.contentView addSubview:price];
        self.price = price;
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(nameLabel);
            make.left.mas_equalTo(priceLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(150);
        }];
        
        UILabel *countryLabel = [UILabel new];
        [self.contentView addSubview:countryLabel];
        countryLabel.text = @"国家:";
        countryLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        countryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameLabel.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(icon.mas_left);
        }];
        
        UILabel *country = [UILabel new];
        [self.contentView addSubview:country];
        self.country = country;
        
        UILabel *levelLabel = [UILabel new];
        [self.contentView addSubview:levelLabel];
        levelLabel.text = @"等级:";
        levelLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        levelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(countryLabel);
            make.left.mas_equalTo(icon.mas_right);
        }];
        
        [country mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(countryLabel);
            make.left.mas_equalTo(countryLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(150);
        }];
        
        UILabel *level = [UILabel new];
        level.text = @"1111";
        [self.contentView addSubview:level];
        self.level = level;
        [level mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(countryLabel);
            make.left.mas_equalTo(levelLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(150);
        }];
        
        UILabel *productAreaLabel = [UILabel new];
        [self.contentView addSubview:productAreaLabel];
        productAreaLabel.text = @"产地:";
        productAreaLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        productAreaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [productAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(countryLabel.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(icon.mas_left);
        }];
        
        UILabel *productArea = [UILabel new];
        [self.contentView addSubview:productArea];
        self.productArea = productArea;
        [productArea mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(productAreaLabel);
            make.left.mas_equalTo(productAreaLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(300);
        }];
        
        
        UILabel *heightLevelLabel = [UILabel new];
        [self.contentView addSubview:heightLevelLabel];
        heightLevelLabel.text = @"海拔:";
        heightLevelLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        heightLevelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [heightLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(productAreaLabel.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(icon.mas_left);
        }];
        
        UILabel *heightLevel = [UILabel new];
        [self.contentView addSubview:heightLevel];
        self.heightLevel = heightLevel;
        [heightLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(heightLevelLabel);
            make.left.mas_equalTo(heightLevelLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(300);
        }];
        
        UILabel *flavorDescLabel = [UILabel new];
        [self.contentView addSubview:flavorDescLabel];
        flavorDescLabel.text = @"风味描述:";
        flavorDescLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        flavorDescLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        [flavorDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(addAvatar);
            make.top.mas_equalTo(heightLevel.mas_bottom).mas_offset(25);
        }];
        
        UILabel *flavorDesc = [UILabel new];
        flavorDesc.lineBreakMode = NSLineBreakByCharWrapping;
        flavorDesc.numberOfLines = 0;
        self.flavorDesc = flavorDesc;
        [self.contentView addSubview:flavorDesc];
        [flavorDesc mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(heightLevel.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(flavorDescLabel.mas_right).mas_offset(10);
            make.width.mas_equalTo(500);
            make.bottom.mas_equalTo(self.contentView.mas_bottom).mas_offset(-10);
        }];
    }
    return self;
}

- (void)configModel:(CFCoffeeModel *)model {
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.avatarURL] placeholderImage:[UIImage imageNamed:@"default_coffee"]];
    self.name.text = model.name;
    self.price.text = model.price;
    self.country.text = model.country;
    self.level.text = model.level;
    self.productArea.text = model.productArea;
    self.heightLevel.text = model.heightLevel;
    self.flavorDesc.text = model.flavorDesc;
}

@end
