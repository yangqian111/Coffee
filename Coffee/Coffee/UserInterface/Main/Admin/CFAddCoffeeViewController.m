//
//  CFAddCoffeeViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewController.h"
#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import "CFAvatarCropViewController.h"

@interface CFAddCoffeeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,weak) UIButton *avatar;
@property (nonatomic,weak) UITextField *name;
@property (nonatomic,weak) UITextField *price;
@property (nonatomic,weak) UIImage *cacheImage;
@property (nonatomic,weak) UIButton *saveBtn;
@property (nonatomic,strong) UIPopoverController *popViewController;
@property (nonatomic,assign) NSUInteger index;

@end

@implementation CFAddCoffeeViewController

- (instancetype)initWithIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"231b13"];
    self.navigationItem.title = @"添加咖啡";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
    [self initUI];
}

- (void)initUI {
    
    UITextField *name = [UITextField new];
    NSDictionary *nameAttributes = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:20],
                                     NSForegroundColorAttributeName: [UIColor whiteColor]
                                     };
    name.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入咖啡名称" attributes:nameAttributes];
    name.textColor = [UIColor whiteColor];
    [self.view addSubview:name];
    self.name = name;
    
    UITextField *price = [UITextField new];
    price.textColor = [UIColor whiteColor];
    NSDictionary *priceAttributes = @{
                                      NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName: [UIColor whiteColor]
                                      };
    price.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入咖啡价格" attributes:priceAttributes];
    [self.view addSubview:price];
    self.price = price;
    
    UIButton *addAvatar = [UIButton new];
    [addAvatar addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [addAvatar setImage:[UIImage imageNamed:@"add_avatar_btn"] forState:UIControlStateNormal];
    [self.view addSubview:addAvatar];
    self.avatar = addAvatar;
    
    UIButton *saveBtn = [UIButton new];
    [saveBtn addTarget:self action:@selector(saveCoffee) forControlEvents:UIControlEventTouchUpInside];
    saveBtn.layer.cornerRadius = 10;
    saveBtn.backgroundColor = [UIColor grayColor];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:saveBtn];
    self.saveBtn = saveBtn;
    
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(self.avatar.mas_bottom).mas_offset(50);
    }];
    
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(name);
        make.width.mas_equalTo(300);
        make.height.mas_equalTo(50);
        make.top.mas_equalTo(name.mas_bottom).mas_offset(50);
    }];
    
    [addAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(name.mas_left);
        make.width.height.mas_equalTo(100);
        make.top.mas_equalTo(100);
    }];
    
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(price.mas_bottom).mas_offset(50);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(50);
    }];
    
}

- (void)choosePhoto:(UIButton *)sender {
    CFAvatarCropViewController *picker = [[CFAvatarCropViewController alloc] init];
    picker.delegate = self;
    [[AppDelegate appDelegate] OrientationMask];
    picker.navigationBar.tintColor = [UIColor blackColor];
    [picker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)saveCoffee {
    //造一个URL
    if (self.name.text.length==0) {
        [self.view makeToast:@"咖啡名不能为空"];
        return;
    }
    if (self.price.text.length == 0) {
        [self.view makeToast:@"咖啡价格不能为空"];
        return;
    }
    
    NSString *imageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
    [[SDWebImageManager sharedManager] saveImageToCache:self.cacheImage forURL:[NSURL URLWithString:imageUUID]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[NSUUID UUID] UUIDString] forKey: @"coffeeId"];
    [dic setObject:self.name.text forKey: @"name"];
    [dic setObject:self.price.text forKey: @"price"];
    [dic setObject:imageUUID forKey: @"avatarURL"];
    [dic setObject:@(_index) forKey:@"index"];
    CFCoffeeModel *model = [[CFCoffeeModel alloc] initWithDictionary:dic];
    [CFDB addCoffee:@[model] finish:^(BOOL success) {
        if (success) {
            [EXCallbackHandle notify:kAddCoffeeSuccess];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"出来了");
    UIImage *orgImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *compressImage = [[UIImage imageWithData:UIImageJPEGRepresentation([UIImage scaleAndRotateImage:orgImage], 0.1)] copy];
    self.cacheImage = compressImage;
    [self.avatar setImage:self.cacheImage forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[AppDelegate appDelegate] OrientationMaskBack];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消了");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [[AppDelegate appDelegate] OrientationMaskBack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
