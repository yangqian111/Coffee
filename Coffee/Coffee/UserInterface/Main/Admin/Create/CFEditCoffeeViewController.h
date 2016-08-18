//
//  CFEditCoffeeViewController.h
//  Coffee
//
//  Created by yangqian on 16/8/17.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFBaseViewController.h"
#import "HSTextView.h"

@protocol CFEditCoffeeViewControllerDelegate <NSObject>

- (void)finishTextEdit:(NSString *)text;
- (void)finishImagEdit:(UIImage *)image;

@end

@interface CFEditCoffeeViewController : CFBaseViewController

@property (nonatomic,weak) id<CFEditCoffeeViewControllerDelegate> vcDelegate;

@end
