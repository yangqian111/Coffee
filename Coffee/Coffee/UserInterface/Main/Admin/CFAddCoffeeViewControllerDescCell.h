//
//  CFAddCoffeeViewControllerDescCell.h
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTextView.h"

@interface CFAddCoffeeViewControllerDescCell : UITableViewCell

@property (nonatomic,weak) HSTextView *desc;//风味描述
@property (nonatomic,weak) UIButton *descImageView;//风味描述图片
@property (nonatomic,strong) UIImage *descImage;

@end
