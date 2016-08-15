//
//  CFAddCoffeeViewControllerTableViewCell.h
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

@interface CFAddCoffeeViewControllerTableViewCell : UITableViewCell


@property (nonatomic,weak) UIButton *avatarImage;
@property (nonatomic,weak) UITextField *name;//名称
@property (nonatomic,weak) UITextField *price;//价格
@property (nonatomic,weak) UITextField *country;//国家
@property (nonatomic,weak) UITextField *level;//等级
@property (nonatomic,weak) UITextField *productArea;//产地
@property (nonatomic,weak) UITextField *heightLevel;//海拔
@property (nonatomic,weak) UITextView *flavorDesc;//风味描述
@property (nonatomic,weak) UIImageView *flavorDescImageView;//风味描述图片
@property (nonatomic,strong) UIImage *avatarImageCache;
@property (nonatomic,strong) UIImage *flavorDescImageCache;

@end
