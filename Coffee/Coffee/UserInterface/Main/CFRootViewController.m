//
//  CFRootViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFRootViewController.h"
#import "CFLoginViewController.h"
#import "CFLoginManager.h"
#import "CFAdminMainViewController.h"
#import "CFUserMainViewController.h"
#import "CFUserManager.h"

@interface CFRootViewController ()

{
@private
    CFAdminMainViewController *_userMainViewController;
    CFLoginViewController *_loginViewController;
    UIViewController *_currentViewController;
}

@end

@implementation CFRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _currentViewController = [self createCurrentViewController];
    [self.view addSubview:_currentViewController.view];
    [self addChildViewController:_currentViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(flipView) name:@"CFLoginStatusChanged" object:nil];
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
    if ([[CFLoginManager manager] isLogin]) {
        currentViewController = [[CFUserManager manager] isCurrentAdmin] ?[[CFAdminMainViewController alloc] init] :[[CFUserMainViewController alloc] init];
        currentNaviViewController = [[UINavigationController alloc] initWithRootViewController:currentViewController];
        return currentNaviViewController;
    }else{
        _loginViewController = [[CFLoginViewController alloc] init];
        currentViewController = _loginViewController;
        return currentViewController;
    }
}

- (void)flipView {
    UIViewController *nextViewController = [self createCurrentViewController];
    nextViewController.view.frame = self.view.bounds;
    [self.view insertSubview:nextViewController.view belowSubview:_currentViewController.view];
    [self addChildViewController:nextViewController];
    
    UIViewController *currentViewController = _currentViewController;
    _currentViewController = nextViewController;
    
    [UIView transitionWithView: self.view duration:1.0 options: UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [currentViewController.view removeFromSuperview];
        [currentViewController removeFromParentViewController];
    } completion:^(BOOL finished) {
        if ([[CFLoginManager manager] isLogin]) {
            _loginViewController = nil;
        }else{
            
        }
        
    }];
}

@end
