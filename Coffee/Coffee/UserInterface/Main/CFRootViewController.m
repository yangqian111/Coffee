//
//  CFRootViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFRootViewController.h"
//#import "CFLoginViewController.h"
#import "CFLoginManager.h"
#import "CFAdminMainViewController.h"
#import "CFUserMainViewController.h"
#import "CFUserManager.h"

@interface CFRootViewController ()

{
@private
    UIViewController *_currentViewController;
}

@end

@implementation CFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentViewController = [self createCurrentViewController];
    [self.view addSubview:_currentViewController.view];
    [self addChildViewController:_currentViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flipToUserMainViewcontroller) name:@"CFToUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flipToAdminViewcontroller) name:@"CFToAdmin" object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _currentViewController.view.frame = self.view.bounds;
}

-(void)dealloc {
    [CFDB close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)createCurrentViewController {
    
    UIViewController *currentNaviViewController = nil;
    UIViewController *currentViewController = nil;
    currentViewController = [[CFAdminMainViewController alloc] init];
    currentNaviViewController = [[UINavigationController alloc] initWithRootViewController:currentViewController];
    return currentNaviViewController;
}

//旋转到用户界面
- (void)flipToUserMainViewcontroller {
    UIViewController *nextViewController = [[UINavigationController alloc] initWithRootViewController:[[CFUserMainViewController alloc] init]];
    nextViewController.view.frame = self.view.bounds;
    [self.view insertSubview:nextViewController.view belowSubview:_currentViewController.view];
    [self addChildViewController:nextViewController];
    
    UIViewController *currentViewController = _currentViewController;
    _currentViewController = nextViewController;
    
    [UIView transitionWithView: self.view duration:1.0 options: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
    } completion:^(BOOL finished) {
        
    }];
}

//旋转到admin界面
- (void)flipToAdminViewcontroller {
    UIViewController *nextViewController = [[UINavigationController alloc] initWithRootViewController:[[CFAdminMainViewController alloc] init]];
    nextViewController.view.frame = self.view.bounds;
    [self.view insertSubview:nextViewController.view belowSubview:_currentViewController.view];
    [self addChildViewController:nextViewController];
    
    UIViewController *currentViewController = _currentViewController;
    _currentViewController = nextViewController;
    
    [UIView transitionWithView: self.view duration:1.0 options: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
    } completion:^(BOOL finished) {
        
    }];
}
@end
