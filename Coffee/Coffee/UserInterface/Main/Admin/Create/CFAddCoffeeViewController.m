//
//  CFAddCoffeeViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAddCoffeeViewController.h"
#import "SDWebImageManager.h"
#import "CFAvatarCropViewController.h"
#import "CFAddCoffeeViewControllerTableViewCell.h"
#import "CFAddCoffeeViewControllerDescTextCell.h"
#import "CFAddCoffeeViewControllerDescImageCell.h"
#import "CFEditCoffeeViewController.h"
#import "CFAddCoffeeViewControllerDescVideoCell.h"

@interface CFAddCoffeeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CFEditCoffeeViewControllerDelegate>
{
    NSMutableArray *_descArr;
    NSMutableArray *_videoArr;
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
@property (nonatomic,copy) NSString *desc;//简介
@property (nonatomic,copy) NSString*videoURL;//视频地址
@property (nonatomic,weak) UIButton *saveBtn;
@property (nonatomic,assign) NSUInteger index;
@property (nonatomic,strong) UIPopoverController *popover;

@end

@implementation CFAddCoffeeViewController

- (instancetype)initWithIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _index = index;
        _descArr = [NSMutableArray array];
        _videoArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *bk = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kApplicationHeight)];
    bk.image = [UIImage imageNamed:@"detail_bk"];
    [self.view addSubview:bk];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake((kApplicationWidth-600)/2, 64, 600, kApplicationHeight-164) style:UITableViewStylePlain];
    //    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.estimatedRowHeight = 44.f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.tableFooterView = [UIView new];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView registerClass:[CFAddCoffeeViewControllerTableViewCell class] forCellReuseIdentifier:@"cellReuser"];
    [self.tableView registerClass:[CFAddCoffeeViewControllerDescTextCell class] forCellReuseIdentifier:@"CFAddCoffeeViewControllerDescTextCell"];
    [self.tableView registerClass:[CFAddCoffeeViewControllerDescImageCell class] forCellReuseIdentifier:@"CFAddCoffeeViewControllerDescImageCell"];
    [self.tableView registerClass:[CFAddCoffeeViewControllerDescVideoCell class] forCellReuseIdentifier:@"CFAddCoffeeViewControllerDescVideoCell"];
    
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
    if (section == 1 ) {
        return _descArr.count;
    }else if (section == 2) {
        return 2;
    }else if (section == 3) {
        return _videoArr.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
    }else if(indexPath.section == 1) {
        id desc = _descArr[indexPath.row];
        if ([desc isKindOfClass:[NSString class]]) {
            CFAddCoffeeViewControllerDescTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFAddCoffeeViewControllerDescTextCell" forIndexPath:indexPath];
            [cell configCell:(NSString *)desc];
            return cell;
        }else{
            CFAddCoffeeViewControllerDescImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFAddCoffeeViewControllerDescImageCell" forIndexPath:indexPath];
            UIImage *image = _descArr[indexPath.row];
            [cell configCell:image];
            return cell;
        }
    }else if(indexPath.section == 2) {
        if (indexPath.row == 0) {
            UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"AddDescCell"];
            if (!addCell) {
                addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddDescCell"];
                addCell.textLabel.text = @"添加简介";
                addCell.textLabel.font = [UIFont systemFontOfSize:16];
                addCell.textLabel.textColor = [UIColor colorWithHexString:@"676561"];
                addCell.contentMode = UIViewContentModeCenter;
                addCell.backgroundColor = [UIColor whiteColor];
            }
            return addCell;
        }else{
            UITableViewCell *addCell = [tableView dequeueReusableCellWithIdentifier:@"AddVideoCell"];
            if (!addCell) {
                addCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddVideoCell"];
                addCell.textLabel.text = @"添加视频";
                addCell.textLabel.font = [UIFont systemFontOfSize:16];
                addCell.textLabel.textColor = [UIColor colorWithHexString:@"676561"];
                addCell.contentMode = UIViewContentModeCenter;
                addCell.backgroundColor = [UIColor whiteColor];
            }
            return addCell;
        }
    }else{
        CFAddCoffeeViewControllerDescVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CFAddCoffeeViewControllerDescVideoCell" forIndexPath:indexPath];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==1 && indexPath.row != _descArr.count) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_descArr removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) {
        CFEditCoffeeViewController *editVC = [[CFEditCoffeeViewController alloc] init];
        editVC.vcDelegate = self;
        [self presentViewController:editVC animated:YES completion:nil];
    }else if(indexPath.section == 2 && indexPath.row == 1) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
        NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
        imagePicker.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];//设置媒体类型为public.movie
        imagePicker.delegate = self;//设置委托
        imagePicker.navigationBar.tintColor = [UIColor blackColor];
        [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
        self.popover = popover;
        popover.passthroughViews = @[self.tableView];
        [popover presentPopoverFromRect:self.tableView.bounds inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
        //        CFAvatarCropViewController *imagePicker = [[CFAvatarCropViewController alloc] init];
        //        imagePicker.navigationBar.tintColor = [UIColor blackColor];
        //        [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        //        imagePicker.delegate = self;
        //        imagePicker.view.backgroundColor = [UIColor clearColor];
        //        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
        //        self.popover = popover;
        //        popover.passthroughViews = @[self.addImageBtn];
        //        [popover presentPopoverFromRect:self.addImageBtn.bounds inView:self.addImageBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        return 20.f;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        view.backgroundColor= [UIColor clearColor];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 20)];
        view.backgroundColor= [UIColor clearColor];
        return view;
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
    for (id param in _descArr) {
        if ([param isKindOfClass:[NSString class]]) {
            NSString *descText = (NSString *)param;
            if (descText.length>0) {
                desc = [desc stringByAppendingString:descText];
            }
        }else{
            UIImage *descImage = param;
            if (descImage) {
                NSString *descImageUUID = [NSString stringWithFormat:@"http://www.coffee.com/%@.jpg",[[NSUUID UUID] UUIDString]];
                [[SDWebImageManager sharedManager] saveImageToCache:descImage forURL:[NSURL URLWithString:descImageUUID]];
                desc = [NSString stringWithFormat:@"%@\n\t%@\n\t",desc,descImageUUID];
            }
        }
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

#pragma mark - imagePicker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    NSURL *newVideoUrl; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *fileName = [formater stringFromDate:[NSDate date]];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp4", fileName]];//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    [_videoArr addObject:newVideoUrl];
    [_tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"取消了");
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

#pragma maek - 编辑简介完成
-(void)finishImagEdit:(UIImage *)image {
    if (image) {
        [_descArr addObject:image];
        [_tableView reloadData];
    }
}

-(void)finishTextEdit:(NSString *)text {
    if (text.length>0) {
        [_descArr addObject:text];
        [_tableView reloadData];
    }
}

@end
