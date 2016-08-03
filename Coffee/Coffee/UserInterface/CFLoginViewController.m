//
//  CFLoginViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFLoginViewController.h"
#import "CFDBManager.h"
#import "CFUserManager.h"
#import "CFLoginManager.h"

@interface CFLoginViewController ()

@property (nonatomic,weak) UIImageView *backgroundImageView;//背景图
@property (nonatomic,weak) UIImageView *iconImageView;
@property (nonatomic,weak) UITextField *userName;
@property (nonatomic,weak) UITextField *password;
@property (nonatomic,weak) UIButton *loginBtn;

@end

@implementation CFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    
}

- (void)initUI {
    
    UIImageView *bkImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bkImageView.image = [UIImage imageNamed:@"login_background"];
    [self.view addSubview:bkImageView];
    self.backgroundImageView = bkImageView;
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.image = [UIImage imageNamed:@"login_icon_image"];
    [self.view addSubview:iconImageView];
    self.iconImageView = iconImageView;
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(125);
        make.top.mas_equalTo(185);
    }];
    
    UITextField *userName = [UITextField new];
    userName.textColor = [UIColor whiteColor];
    userName.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftImageViewUserName = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    leftImageViewUserName.contentMode = UIViewContentModeLeft;
    leftImageViewUserName.image = [UIImage imageNamed:@"username_left_image"];
    userName.leftView = leftImageViewUserName;
    [self.view addSubview:userName];
    self.userName = userName;
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.iconImageView.mas_bottom).mas_offset(60);
        make.width.mas_equalTo(465);
        make.height.mas_equalTo(20);
    }];
    
    UIImageView *userNameLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_line"]];
    [self.view addSubview:userNameLine];
    [userNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.userName).mas_offset(10);
        make.width.mas_equalTo(475);
    }];
    
    UITextField *password = [UITextField new];
    password.textColor = [UIColor whiteColor];
    password.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftImageViewPassword = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    leftImageViewPassword.contentMode = UIViewContentModeLeft;
    leftImageViewPassword.image = [UIImage imageNamed:@"password_left_image"];
    password.leftView = leftImageViewPassword;
    [self.view addSubview:password];
    self.password = password;
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.userName.mas_bottom).mas_offset(55);
        make.width.mas_equalTo(userName);
        make.height.mas_equalTo(userName);
    }];
    
    UIImageView *passwordLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_line"]];
    [self.view addSubview:passwordLine];
    [passwordLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.password).mas_offset(10);
        make.width.mas_equalTo(userNameLine);
    }];
    
    UIButton *loginBtn = [UIButton new];
    [loginBtn addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn_bk"] forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(33);
        make.top.mas_equalTo(password.mas_bottom).mas_offset(55);
    }];
}

- (void)doLogin {
    if (self.userName.text.length == 0) {
        [self.view makeToast:@"用户名不能为空"];
        return;
    }
    if (self.password.text.length == 0) {
        [self.view makeToast:@"密码不能为空"];
        return;
    }
    
    [[CFLoginManager manager] login:self.userName.text password:self.password.text finish:^(BOOL isSuccess) {
        
    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
//
//- (void)keyboardWillShow:(NSNotification *)notification {
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.top = self.view.top - 100;
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification {
//    [UIView animateWithDuration:0.25 animations:^{
//        self.view.top = self.view.top + 100;
//    }];
//}
@end
