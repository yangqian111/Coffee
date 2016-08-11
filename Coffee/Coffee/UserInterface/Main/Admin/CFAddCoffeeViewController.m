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
#import "CFAddCoffeeViewControllerTableViewCell.h"
#import "CFAddCoffeeViewControllerDescCell.h"

@interface CFAddCoffeeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIButton *_tableFootView;
    NSInteger _countRows;
    NSMutableArray *_descArr;
}


@property (nonatomic,strong) UITextField *name;//名称
@property (nonatomic,strong) UITextField *price;//价格
@property (nonatomic,strong) UITextField *country;//国家
@property (nonatomic,strong) UITextField *level;//等级
@property (nonatomic,strong) UITextField *productArea;//产地
@property (nonatomic,strong) UITextField *heightLevel;//海拔
@property (nonatomic,strong) UITextView *flavorDesc;//风味描述
@property (nonatomic,strong) UIImage *avatarImageCache;
@property (nonatomic,strong) UIImage *flavorDescImageCache;


@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *descViewArr;
@property (nonatomic,copy) NSString *desc;//简介
@property (nonatomic,copy) NSString*videoURL;//视频地址
@property (nonatomic,weak) UIButton *saveBtn;
@property (nonatomic,assign) NSUInteger index;



@end

@implementation CFAddCoffeeViewController

- (instancetype)initWithIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _index = index;
        _countRows = 1;
        _descViewArr = [NSMutableArray array];
        _descArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kApplicationHeight)];
    bk.image = [UIImage imageNamed:@"detail_bk"];
    [self.view addSubview:bk];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kApplicationWidth, kApplicationHeight-164) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 44.f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    //    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView registerClass:[CFAddCoffeeViewControllerTableViewCell class] forCellReuseIdentifier:@"cellReuser"];
    [self.tableView registerClass:[CFAddCoffeeViewControllerDescCell class] forCellReuseIdentifier:@"descCellReuser"];
    
    UIButton *saveBtn = [UIButton new];
    [saveBtn addTarget:self action:@selector(saveCoffee) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor lightGrayColor]];
    saveBtn.layer.cornerRadius = 10;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview: saveBtn];
    self.saveBtn = saveBtn;
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
    }];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _descArr.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CFAddCoffeeViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuser" forIndexPath:indexPath];
        self.name = cell.name;
        self.price = cell.price;
        self.country = cell.country;
        self.level =  cell.level;
        self.productArea = cell.productArea;
        self.heightLevel = cell.heightLevel;
        self.flavorDesc = cell.flavorDesc;
        self.avatarImageCache = cell.avatarImageCache;
        self.flavorDescImageCache = cell.flavorDescImageCache;
        return cell;
    }else{
        CFAddCoffeeViewControllerDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCellReuser" forIndexPath:indexPath];
        //        NSString *key = [NSString stringWithFormat:@"%d--%d",indexPath.section,indexPath.row];
        NSMutableDictionary *dic = _descArr[indexPath.row-1];
        
        [dic setObject:cell.desc forKey:@"text"];
        [dic setObject:cell.descImageView forKey:@"image"];
        [_descDic setObject:dic forKey:key];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, 50)];
    [btn setTitle:@"添加简介" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    [btn setTitleColor:[UIColor colorWithHexString:@"614A3D"] forState:UIControlStateNormal];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"kuang9"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addDesc) forControlEvents:UIControlEventTouchUpInside];
    _tableFootView = btn;
    _tableFootView.hidden = YES;
    return btn;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50.f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row != 0) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _countRows-=1;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSString *key = [NSString stringWithFormat:@"%d--%d",indexPath.section,indexPath.row];
        [_descDic removeObjectForKey:key];
    }
}

- (void)saveCoffee {
    
    if (self.name.text.length == 0 || self.price.text.length == 0) {
        [self.view makeToast:@"咖啡名或价格不能为空"];
        return;
    }
    NSString *cacheImageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
    NSString *flavorDescImageCacheUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
    UIImage *cacheImage = self.avatarImageCache;
    UIImage *flavorDescImageCache = self.flavorDescImageCache;
    [[SDWebImageManager sharedManager] saveImageToCache:flavorDescImageCache forURL:[NSURL URLWithString:flavorDescImageCacheUUID]];
    [[SDWebImageManager sharedManager] saveImageToCache:cacheImage forURL:[NSURL URLWithString:cacheImageUUID]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[NSUUID UUID] UUIDString] forKey: @"coffeeId"];
    [dic setObject:self.name.text forKey: @"name"];
    [dic setObject:self.price.text forKey: @"price"];
    [dic setObject:cacheImageUUID forKey: @"avatarURL"];
    [dic setObject:@(_index) forKey:@"index"];
    [dic setObject:self.country.text forKey: @"country"];
    [dic setObject:self.productArea.text forKey: @"productArea"];
    [dic setObject:self.heightLevel.text forKey: @"heightLevel"];
    [dic setObject:self.level.text forKey: @"level"];
    [dic setObject:self.flavorDesc.text forKey: @"flavorDesc"];
    [dic setObject:flavorDescImageCacheUUID forKey: @"flavorDescURL"];
    
    NSString *desc = @"";
    for (NSString *key in _descDic.allKeys) {
        NSDictionary *dic = _descDic[key];
        HSTextView *textView = dic[@"text"];
        if (textView.text.length>0) {
            desc = [desc stringByAppendingString:textView.text];
        }
        UIButton *btn = dic[@"image"];
        UIImage *image = btn.currentBackgroundImage;
        NSString *descImageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:descImageUUID]];
        desc = [desc stringByAppendingFormat:@"%@\n\t%@\n\t",desc,descImageUUID];
    }
    [dic setObject:desc forKey:@"desc"];
    CFCoffeeModel *model = [[CFCoffeeModel alloc] initWithDictionary:dic];
    [CFDB addCoffee:@[model] finish:^(BOOL success) {
        if (success) {
            [EXCallbackHandle notify:kAddCoffeeSuccess];
            [self.navigationController popViewControllerAnimated:YES];
            [self.view makeToast:@"添加成功"];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y == scrollView.contentSize.height - scrollView.frame.size.height) {
        _tableFootView.hidden = NO;
    }else{
        _tableFootView.hidden =  YES;
    }
}

- (void)addDesc {
    _countRows++;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_countRows-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    _tableFootView.hidden = YES;
}

@end
