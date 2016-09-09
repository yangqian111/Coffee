//
//  CFAddCoffeeViewControllerTableViewCell.h
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"

@protocol CFAddCoffeeViewControllerTableViewCellDelegate <NSObject>

- (void)finishEdit:(NSString *)name price:(NSString *)price properties:(NSString *)properties headImageURL:(NSString *)headImageURL;

@end

@interface CFAddCoffeeViewControllerTableViewCell : UITableViewCell

@property (nonatomic,weak) UIButton *avatarImage;
@property (nonatomic,weak) UITextField *name;//名称
@property (nonatomic,weak) UITextField *price;//价格
@property (nonatomic,weak) UITextView *properties;//自定义描述
@property (nonatomic,weak) id<CFAddCoffeeViewControllerTableViewCellDelegate> delegate;

@end
