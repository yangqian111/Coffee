//
//  CFUpdateCoffeeViewController.m
//  Coffee
//
//  Created by yangqian on 16/8/15.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFUpdateCoffeeViewController.h"
#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import "CFAvatarCropViewController.h"
#import "CFAddCoffeeViewControllerTableViewCell.h"
#import "CFAddCoffeeViewControllerDescTextCell.h"
#import "UIButton+WebCache.h"
#import "CFUpdateCoffeeViewControllerDescCell.h"

@interface CFUpdateCoffeeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CFUpdateCoffeeViewControllerDescCellDelegate,CFAddCoffeeViewControllerTableViewCellDelegate>
{
    UIButton *_tableFootView;
    NSInteger _countRows;
    NSMutableArray *_descArr;
    BOOL _isFirst;
    NSString *_name;
    NSString *_price;
    NSString *_properties;
    UIImage *_avatar;
}

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,copy) NSString *desc;//简介
@property (nonatomic,copy) NSString*videoURL;//视频地址
@property (nonatomic,weak) UIButton *saveBtn;
@property (nonatomic,weak) UIButton *deleteBtn;
@property (nonatomic,assign) NSUInteger index;

@property (nonatomic,strong) CFCoffeeModel *coffee;

@end

@implementation CFUpdateCoffeeViewController

- (instancetype)initWithCoffee:(CFCoffeeModel *)coffee {
    self = [super init];
    if (self) {
        _descArr = [NSMutableArray array];
        _isFirst = YES;
        _coffee = coffee;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *desc = _coffee.desc;
    // 分割文本到数组
    NSArray *textArray = [desc componentsSeparatedByString:@"\n\t"];
    for (NSString *s in textArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        if ([s containsString:@"http://"]) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:s];
            [dic setObject:image forKey:@"image"];
        }else{
            [dic setObject:s forKey:@"text"];
        }
        [_descArr addObject:dic];
    }
    
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kApplicationHeight)];
    bk.image = [UIImage imageNamed:@"detail_bk"];
    [self.view addSubview:bk];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kApplicationWidth, kApplicationHeight-164) style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.estimatedRowHeight = 44.f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView registerClass:[CFAddCoffeeViewControllerTableViewCell class] forCellReuseIdentifier:@"cellReuser"];
    [self.tableView registerClass:[CFAddCoffeeViewControllerDescTextCell class] forCellReuseIdentifier:@"CFAddCoffeeViewControllerDescTextCell"];
    
    UIButton *saveBtn = [UIButton new];
    [saveBtn addTarget:self action:@selector(saveCoffee) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:[UIColor lightGrayColor]];
    saveBtn.layer.cornerRadius = 10;
    saveBtn.layer.masksToBounds = YES;
    [self.view addSubview: saveBtn];
    self.saveBtn = saveBtn;
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo((kApplicationWidth-500)/2);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-20);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(200);
    }];
    
    UIButton *deleteBtn = [UIButton new];
    [deleteBtn addTarget:self action:@selector(deleteCoffee) forControlEvents:UIControlEventTouchUpInside];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setBackgroundColor:[UIColor lightGrayColor]];
    deleteBtn.layer.cornerRadius = 10;
    deleteBtn.layer.masksToBounds = YES;
    [self.view addSubview: deleteBtn];
    self.deleteBtn = deleteBtn;
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(saveBtn.mas_right).mas_offset(100);
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
        cell.delegate = self;
        if (_isFirst) {
            cell.name.text = _coffee.name;
            cell.price.text = _coffee.price;
            cell.properties.text = _coffee.properties;
            [cell.avatarImage sd_setImageWithURL:[NSURL URLWithString:_coffee.avatarURL] forState: UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_image"]];
            _isFirst = NO;
        }
        return cell;
    }else{
        CFUpdateCoffeeViewControllerDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCellReuser" forIndexPath:indexPath];
        cell.index = indexPath.row - 1;
        cell.cellDelegate = self;
        [cell configCell: _descArr[indexPath.row-1]];
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
        [_descArr removeObjectAtIndex:indexPath.row - 1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)deleteCoffee {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除吗？" message:@"删除不可恢复" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [CFDB deleteCoffee:_coffee.coffeeId finish:^(BOOL success) {
            if (success) {
                [EXCallbackHandle notify:kUpdateCoffeeSuccess];
                [self popCurrentViewController];
            }
					   }];
    }];
    [alert addAction:action];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)saveCoffee {
    if (_name.length == 0 || _price.length == 0) {
        [self.view makeToast:@"咖啡名或价格不能为空"];
        return;
    }
    NSString *cacheImageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
    NSString *flavorDescImageCacheUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
    //    UIImage *cacheImage = self.avatarImageCache;
    //    UIImage *flavorDescImageCache = self.flavorDescImageCache;
    //    [[SDWebImageManager sharedManager] saveImageToCache:flavorDescImageCache forURL:[NSURL URLWithString:flavorDescImageCacheUUID]];
    //    [[SDWebImageManager sharedManager] saveImageToCache:cacheImage forURL:[NSURL URLWithString:cacheImageUUID]];
    //    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //    [dic setObject:_coffee.coffeeId forKey: @"coffeeId"];
    //    [dic setObject:self.name.text forKey: @"name"];
    //    [dic setObject:self.price.text forKey: @"price"];
    //    [dic setObject:cacheImageUUID forKey: @"avatarURL"];
    //    [dic setObject:self.country.text forKey: @"country"];
    //    [dic setObject:self.productArea.text forKey: @"productArea"];
    //    [dic setObject:self.heightLevel.text forKey: @"heightLevel"];
    //    [dic setObject:self.level.text forKey: @"level"];
    //    [dic setObject:self.flavorDesc.text forKey: @"flavorDesc"];
    //    [dic setObject:flavorDescImageCacheUUID forKey: @"flavorDescURL"];
    //
    //    NSString *desc = @"";
    //    for (NSDictionary *param in _descArr) {
    //        NSString *descText = param[@"text"];
    //        if (descText.length>0) {
    //            desc = [desc stringByAppendingString:descText];
    //        }
    //        UIImage *descImage = param[@"image"];
    //        if (descImage) {
    //            NSString *descImageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
    //            [[SDWebImageManager sharedManager] saveImageToCache:descImage forURL:[NSURL URLWithString:descImageUUID]];
    //            desc = [NSString stringWithFormat:@"%@\n\t%@\n\t",desc,descImageUUID];
    //        }
    //    }
    //    [dic setObject:desc forKey:@"desc"];
    //    CFCoffeeModel *model = [[CFCoffeeModel alloc] initWithDictionary:dic];
    //    [CFDB updateCoffee:@[model] finish:^(BOOL success) {
    //        if (success) {
    //            [EXCallbackHandle notify:kUpdateCoffeeSuccess];
    //            [self.navigationController popViewControllerAnimated:YES];
    //            [self.view makeToast:@"添加成功"];
    //        }
    //    }];
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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [_descArr addObject:dic];
    [self.tableView reloadData];
    _tableFootView.hidden = YES;
}

-(void)finishDescText:(NSString *)text index:(NSInteger)index {
    NSMutableDictionary *dic = _descArr[index];
    if (dic) {
        [dic setObject:text forKey:@"text"];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:text forKey:@"text"];
        [_descArr addObject:dic];
    }
}

- (void)finishDescImage:(UIImage *)image index:(NSInteger)index {
    NSMutableDictionary *dic = _descArr[index];
    if (dic) {
        [dic setObject: image forKey: @"image"];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject: image forKey: @"image"];
        [_descArr addObject:dic];
    }
}

-(void)finishEdit:(NSString *)name price:(NSString *)price properties:(NSString *)properties headImage:(UIImage *)headImage {
    _name = name;
    _price = price;
    _properties = properties;
    _avatar = headImage;
}

@end