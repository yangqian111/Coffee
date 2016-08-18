//
//  CFAddCoffeeViewControllerDescImageCell.m
//  Coffee
//
//  Created by yangqian on 16/8/17.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewControllerDescImageCell.h"

@interface CFAddCoffeeViewControllerDescImageCell ()

@property (nonatomic,weak) UIImageView *descImage;

@end

@implementation CFAddCoffeeViewControllerDescImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageView = [UIImageView new];
        [self.contentView addSubview:imageView];
        self.descImage = imageView;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView);
            make.right.mas_equalTo(self.contentView);
            make.height.mas_equalTo(150);
            make.top.mas_equalTo(self.contentView).mas_equalTo(5);
            make.bottom.mas_equalTo(self.contentView).mas_offset(-5);
        }];
    }
    return self;
}

- (void)configCell:(UIImage *)image {
    self.descImage.image = image;
}

@end
