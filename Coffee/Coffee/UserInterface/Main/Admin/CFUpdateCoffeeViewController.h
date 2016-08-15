//
//  CFUpdateCoffeeViewController.h
//  Coffee
//
//  Created by yangqian on 16/8/15.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSTextView.h"

#define kUpdateCoffeeSuccess @"kUpdateCoffeeSuccess"

@class CFCoffeeModel;

@interface CFUpdateCoffeeViewController : CFBaseViewController

- (instancetype)initWithCoffee:(CFCoffeeModel *)coffee;

@end