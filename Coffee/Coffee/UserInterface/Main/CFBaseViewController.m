//
//  CFBaseViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/8/3.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFBaseViewController.h"

@implementation CFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)popCurrentViewController {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
