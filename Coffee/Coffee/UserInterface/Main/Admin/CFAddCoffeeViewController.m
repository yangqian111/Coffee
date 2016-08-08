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
}

@property (nonatomic,weak) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *descViewArr;
@property (nonatomic,copy) NSString *desc;//简介
@property (nonatomic,copy) NSString*videoURL;//视频地址
@property (nonatomic,strong) UIImage *avatarImage;
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
        _countRows = 2;
        _descViewArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kApplicationHeight)];
    bk.image = [UIImage imageNamed:@"detail_bk"];
    [self.view addSubview:bk];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kApplicationWidth, kApplicationHeight-64) style:UITableViewStylePlain];
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
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"231b13"];
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
    return _countRows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CFAddCoffeeViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuser" forIndexPath:indexPath];
        return cell;
    }else{
        CFAddCoffeeViewControllerDescCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descCellReuser" forIndexPath:indexPath];
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, 50)];
    [btn setTitle:@"添加模块" forState:UIControlStateNormal];
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
    if (indexPath.row != 0 && indexPath.row != 1) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        _countRows-=1;
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

//- (void)choosePhoto:(UIButton *)sender {
//    CFAvatarCropViewController *imagePicker = [[CFAvatarCropViewController alloc] init];
//    imagePicker.navigationBar.tintColor = [UIColor blackColor];
//    [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
//    imagePicker.delegate = self;
//    imagePicker.view.backgroundColor = [UIColor clearColor];
//    UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
//    self.popover = popover;
//    popover.passthroughViews = @[self.scrollview];
//    [popover presentPopoverFromRect:self.avatar.bounds inView:self.avatar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//}
//
//- (void)saveCoffee {
//    //造一个URL
//    if (self.name.text.length==0) {
//        [self.scrollview makeToast:@"咖啡名不能为空"];
//        return;
//    }
//    if (self.price.text.length == 0) {
//        [self.scrollview makeToast:@"咖啡价格不能为空"];
//        return;
//    }
//
//    NSString *imageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
//    [[SDWebImageManager sharedManager] saveImageToCache:self.avatarImage forURL:[NSURL URLWithString:imageUUID]];
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setObject:[[NSUUID UUID] UUIDString] forKey: @"coffeeId"];
//    [dic setObject:self.name.text forKey: @"name"];
//    [dic setObject:self.price.text forKey: @"price"];
//    [dic setObject:imageUUID forKey: @"avatarURL"];
//    [dic setObject:@(_index) forKey:@"index"];
//    CFCoffeeModel *model = [[CFCoffeeModel alloc] initWithDictionary:dic];
//    [CFDB addCoffee:@[model] finish:^(BOOL success) {
//        if (success) {
//            [EXCallbackHandle notify:kAddCoffeeSuccess];
//            //            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }];
//}
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
//    NSLog(@"出来了");
//    UIImage *orgImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    UIImage *compressImage = [[UIImage imageWithData:UIImageJPEGRepresentation([UIImage scaleAndRotateImage:orgImage], 0.1)] copy];
//    self.avatarImage = compressImage;
//    [self.avatar setImage:self.avatarImage forState:UIControlStateNormal];
//    [self.popover dismissPopoverAnimated:YES];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    NSLog(@"取消了");
//    [self.popover dismissPopoverAnimated:YES];
//}

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
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_countRows-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    _tableFootView.hidden = YES;
}

@end
