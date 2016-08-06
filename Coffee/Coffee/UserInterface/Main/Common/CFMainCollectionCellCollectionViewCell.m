//
//  CFUserMainCollectionCellCollectionViewCell.m
//  Coffee
//
//  Created by 羊谦 on 16/7/28.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFMainCollectionCellCollectionViewCell.h"
#import "CFCoffeeModel.h"
#import "UIImageView+WebCache.h"

@interface CFMainCollectionCellCollectionViewCell ()

@property (nonatomic,weak) UIImageView *image;
@property (nonatomic,weak) UILabel *name;
@property (nonatomic,weak) UILabel *price;

@end

@implementation CFMainCollectionCellCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *image = [UIImageView new];
        image.layer.masksToBounds = YES;
        image.layer.cornerRadius = 50;
        [self.contentView addSubview: image];
        self.image = image;
        [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.contentView);
            make.width.height.mas_equalTo(100);
        }];
        
        UILabel *name=  [UILabel new];
        name.textColor = [UIColor colorWithHexString:@"C2776C"];
        name.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:25.f];
        
        [self.contentView addSubview:name];
        self.name = name;
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(image);
            make.top.mas_equalTo(image.mas_bottom).mas_offset(5);
        }];
        
        UILabel *price = [UILabel new];
        price.textColor = [UIColor whiteColor];
        price.font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
        self.price = price;
        [self.contentView addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(name);
            make.top.mas_equalTo(name.mas_bottom).mas_offset(7);
        }];
    }
    return self;
}

- (void)configCell:(CFCoffeeModel *)model {
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.avatarURL] placeholderImage:[UIImage imageNamed:@"defaut_coffee"]];
    self.name.text = model.name;
    self.price.text = [NSString stringWithFormat:@"￥ %@",model.price];
}

@end
