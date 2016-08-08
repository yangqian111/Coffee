//
//  CFAddCoffeeViewControllerDescCell.m
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewControllerDescCell.h"

@implementation CFAddCoffeeViewControllerDescCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        //        UILabel *descLabel = [UILabel new];
        //        [self.contentView addSubview:descLabel];
        //        descLabel.text = @"简介:";
        //        descLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
        //        descLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
        //
        HSTextView *desc = [HSTextView new];
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
        
        //        [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.mas_equalTo(240);
        //            make.centerY.mas_equalTo(self.desc);
        //        }];
        
        UIButton *descImageView = [UIButton new];
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
            make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
        }];
    }
    return self;
}

@end
