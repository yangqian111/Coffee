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
@property (nonatomic,strong) UIImage *avatarImage;
@property (nonatomic,weak) UITextField *name;//名称
@property (nonatomic,weak) UITextField *price;//价格
@property (nonatomic,weak) UITextField *country;//国家
@property (nonatomic,weak) UITextField *level;//等级
@property (nonatomic,weak) UITextField *productArea;//产地
@property (nonatomic,weak) UITextField *heightLevel;//海拔
@property (nonatomic,weak) UITextView *flavorDesc;//风味描述
@property (nonatomic,readonly,copy) UIImageView *flavorDescImageView;//风味描述图片
@property (nonatomic,readonly,copy) NSString *desc;//简介
@property (nonatomic,readonly,copy) NSString*videoURL;//视频地址


@property (nonatomic,weak) UIButton *saveBtn;
@property (nonatomic,strong) UIPopoverController *popViewController;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,strong) UIPopoverController *popover;

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
    UIImageView *bk = [[UIImageView alloc] initWithFrame:self.view.frame];
    bk.image = [UIImage imageNamed:@"detail_bk"];
    [self.view addSubview:bk];
    self.view.backgroundColor = [UIColor colorWithHexString:@"231b13"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)initUI {
    
    UIImageView *icon = [UIImageView new];
    [self.view addSubview:icon];
    icon.image = [UIImage imageNamed:@"icon"];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(60);
        make.width.mas_equalTo(240);
        make.height.mas_equalTo(125);
    }];
    
    UIButton *addAvatar = [UIButton new];
    addAvatar.layer.cornerRadius = 65;
    addAvatar.layer.masksToBounds = YES;
    [addAvatar addTarget:self action:@selector(choosePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [addAvatar setBackgroundImage:[UIImage imageNamed:@"default_image"] forState:UIControlStateNormal];
    [self.view addSubview:addAvatar];
    self.avatar = addAvatar;
    [addAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(icon.mas_left).mas_offset(-30);
        make.width.height.mas_equalTo(130);
        make.top.mas_equalTo(icon.mas_bottom).mas_offset(40);
    }];
    
    UILabel *nameLabel = [UILabel new];
    [self.view addSubview:nameLabel];
    nameLabel.text = @"名称:";
    nameLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
    nameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    UITextField *name = [UITextField new];
    name.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
    name.leftViewMode = UITextFieldViewModeAlways;
    name.background = [UIImage imageNamed:@"short_biankuang"];
    name.textColor = [UIColor blackColor];
    [self.view addSubview:name];
    self.name = name;
    [name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(addAvatar);
    }];
    
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(icon.mas_left);
        make.centerY.mas_equalTo(self.name);
    }];
    
    UILabel *priceLabel = [UILabel new];
    [self.view addSubview:priceLabel];
    priceLabel.text = @"价格:";
    priceLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
    priceLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    UITextField *price = [UITextField new];
    price.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
    price.leftViewMode = UITextFieldViewModeAlways;
    price.background = [UIImage imageNamed:@"short_biankuang"];
    price.textColor = [UIColor blackColor];
    [self.view addSubview:price];
    self.price = price;
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(addAvatar);
    }];
    
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(name.mas_right).mas_offset(25);
        make.centerY.mas_equalTo(self.name);
    }];
    
    UILabel *countryLabel = [UILabel new];
    [self.view addSubview:countryLabel];
    countryLabel.text = @"国家:";
    countryLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
    countryLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    UITextField *country = [UITextField new];
    country.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
    country.leftViewMode = UITextFieldViewModeAlways;
    country.background = [UIImage imageNamed:@"short_biankuang"];
    country.textColor = [UIColor blackColor];
    [self.view addSubview:country];
    self.country = country;
    [country mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(countryLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(name.mas_bottom).mas_offset(10);
    }];
    
    [countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.centerY.mas_equalTo(self.country);
    }];
    
    UILabel *levelLabel = [UILabel new];
    [self.view addSubview:levelLabel];
    levelLabel.text = @"价格:";
    levelLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
    levelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    UITextField *level = [UITextField new];
    level.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
    level.leftViewMode = UITextFieldViewModeAlways;
    level.background = [UIImage imageNamed:@"short_biankuang"];
    level.textColor = [UIColor blackColor];
    [self.view addSubview:level];
    self.level = level;
    [level mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(country);
    }];
    
    [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(country.mas_right).mas_offset(25);
        make.centerY.mas_equalTo(self.country);
    }];
    
    UILabel *productAreaLabel = [UILabel new];
    [self.view addSubview:productAreaLabel];
    productAreaLabel.text = @"产地:";
    productAreaLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
    productAreaLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    UITextField *productArea = [UITextField new];
    productArea.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
    productArea.leftViewMode = UITextFieldViewModeAlways;
    productArea.background = [UIImage imageNamed:@"medim_biankuang"];
    productArea.textColor = [UIColor blackColor];
    [self.view addSubview:productArea];
    self.productArea = productArea;
    [productArea mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(productAreaLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(370);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(country.mas_bottom).mas_offset(10);
    }];
    
    [productAreaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.centerY.mas_equalTo(self.productArea);
    }];
    
    UILabel *heightLevelLabel = [UILabel new];
    [self.view addSubview:heightLevelLabel];
    heightLevelLabel.text = @"产地:";
    heightLevelLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
    heightLevelLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    UITextField *heightLevel = [UITextField new];
    heightLevel.leftView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 4, 10)];
    heightLevel.leftViewMode = UITextFieldViewModeAlways;
    heightLevel.background = [UIImage imageNamed:@"medim_biankuang"];
    heightLevel.textColor = [UIColor blackColor];
    [self.view addSubview:heightLevel];
    self.heightLevel = heightLevel;
    [heightLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(heightLevelLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(370);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(productArea.mas_bottom).mas_offset(10);
    }];
    
    [heightLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel);
        make.centerY.mas_equalTo(self.heightLevel);
    }];
    
    UILabel *flavorDescLabel = [UILabel new];
    [self.view addSubview:flavorDescLabel];
    flavorDescLabel.text = @"风味描述:";
    flavorDescLabel.textColor = [UIColor colorWithHexString:@"5e544a"];
    flavorDescLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    
    UITextView *flavorDesc = [UITextView new];
    flavorDesc.font = [UIFont systemFontOfSize:18];
    flavorDesc.layer.contents = (id)[UIImage imageNamed:@"biankuang3"].CGImage;
    flavorDesc.textColor = [UIColor blackColor];
    [self.view addSubview:flavorDesc];
    self.flavorDesc = flavorDesc;
    [flavorDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(flavorDescLabel.mas_right).mas_offset(5);
        make.width.mas_equalTo(495);
        make.height.mas_equalTo(70);
        make.top.mas_equalTo(heightLevel.mas_bottom).mas_offset(10);
    }];
    
    [flavorDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addAvatar);
        make.centerY.mas_equalTo(self.flavorDesc);
    }];
    
}

- (void)choosePhoto:(UIButton *)sender {
    CFAvatarCropViewController *imagePicker = [[CFAvatarCropViewController alloc] init];
    imagePicker.navigationBar.tintColor = [UIColor blackColor];
    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    imagePicker.delegate = self;
    imagePicker.view.backgroundColor = [UIColor clearColor];
    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
    self.popover = popover;
    popover.passthroughViews = @[self.view];
    [popover presentPopoverFromRect:self.avatar.bounds inView:self.avatar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    [[SDWebImageManager sharedManager] saveImageToCache:self.avatarImage forURL:[NSURL URLWithString:imageUUID]];
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
            //            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"出来了");
    UIImage *orgImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *compressImage = [[UIImage imageWithData:UIImageJPEGRepresentation([UIImage scaleAndRotateImage:orgImage], 0.1)] copy];
    self.avatarImage = compressImage;
    [self.avatar setImage:self.avatarImage forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消了");
    [self.popover dismissPopoverAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
