//
//  CFAddCoffeeViewControllerDescCell.m
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewControllerDescTextCell.h"
#import "CFAvatarCropViewController.h"

@interface CFAddCoffeeViewControllerDescTextCell ()

@property (nonatomic,weak) UILabel *text;//简述

@end

@implementation CFAddCoffeeViewControllerDescTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [UILabel new];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        self.text = label;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor colorWithHexString:@"676561"];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.top.mas_equalTo(self.contentView).mas_equalTo(20);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-20);
        }];
    }
    return self;
}

-(void)configCell:(NSString *)text1 {
    self.text.text = text1;
}

@end
