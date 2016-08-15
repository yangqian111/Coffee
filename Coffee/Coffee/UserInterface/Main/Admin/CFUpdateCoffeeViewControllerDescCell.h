//
//  CFUpdateCoffeeViewControllerDescCell.h
//  Coffee
//
//  Created by yangqian on 16/8/15.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTextView.h"

@protocol CFUpdateCoffeeViewControllerDescCellDelegate <NSObject>

- (void)finishDescText:(NSString *)text index:(NSInteger) index;
- (void)finishDescImage:(UIImage *)image index:(NSInteger) index;

@end

@interface CFUpdateCoffeeViewControllerDescCell : UITableViewCell

@property (nonatomic,weak) id<CFUpdateCoffeeViewControllerDescCellDelegate> cellDelegate;
@property (nonatomic,assign) NSInteger index;

- (void)configCell:(NSDictionary *)dic;

@end
