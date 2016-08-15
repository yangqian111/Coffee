//
//  CFAddCoffeeViewControllerDescCell.h
//  Coffee
//
//  Created by 羊谦 on 16/8/8.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTextView.h"

@protocol CFAddCoffeeViewControllerDescCellDelegate <NSObject>

- (void)finishDescText:(NSString *)text index:(NSInteger) index;
- (void)finishDescImage:(UIImage *)image index:(NSInteger) index;

@end

@interface CFAddCoffeeViewControllerDescCell : UITableViewCell

@property (nonatomic,weak) id<CFAddCoffeeViewControllerDescCellDelegate> cellDelegate;
@property (nonatomic,assign) NSInteger index;

- (void)configCell:(NSDictionary *)dic;

@end
