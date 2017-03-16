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
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface CFAddCoffeeViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,CFEditCoffeeViewControllerDelegate,CFAddCoffeeViewControllerTableViewCellDelegate>
{
    NSMutableArray *_descArr;
    NSMutableArray *_videoArr;
    NSString *_name;
    NSString *_price;
    NSString *_properties;
    NSString *_avatar;
}

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
        cell.delegate = self;
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
        NSURL *videoURL = _videoArr.firstObject;
        [cell configCell:videoURL];
        return cell;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==1 || indexPath.section == 3) {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {
            [_descArr removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [_videoArr removeAllObjects];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) {
        CFEditCoffeeViewController *editVC = [[CFEditCoffeeViewController alloc] init];
        editVC.vcDelegate = self;
        [self presentViewController:editVC animated:YES completion:nil];
    }else if(indexPath.section == 2 && indexPath.row == 1) {
        if (_videoArr.count>0) {
            [self.view makeToast:@"请先删除已选视频"];
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
//        NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];//设置媒体类型为public.movie
        imagePicker.delegate = self;//设置委托
        imagePicker.navigationBar.tintColor = [UIColor blackColor];
        [imagePicker.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
        UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
        self.popover = popover;
        popover.passthroughViews = @[self.tableView];
        [popover presentPopoverFromRect:self.tableView.bounds inView:self.tableView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
    
    if (_name.length == 0 || _price.length == 0) {
        [self.view makeToast:@"咖啡名或价格不能为空"];
        return;
    }
    if (_properties.length == 0) {
        [self.view makeToast:@"咖啡描述不能为空"];
        return;
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[[NSUUID UUID] UUIDString] forKey: @"coffeeId"];
    [dic setObject:_name forKey: @"name"];
    [dic setObject:_price forKey: @"price"];
    if (_avatar.length>0) {
        [dic setObject:_avatar forKey: @"avatarURL"];
    }
    [dic setObject:@(_index) forKey:@"index"];
    [dic setObject:_properties forKey:@"properties"];
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
    NSURL *url = _videoArr.firstObject;
    if (url) {
        NSString *urlStr = [url absoluteString];
        [dic setObject:urlStr forKey:@"videoURL"];
    }
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
    // 这里的代码会在主线程执行
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *newVideoUrl; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    NSString *fileName = [formater stringFromDate:[NSDate date]];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@.mp4", fileName]];//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}


- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted: {
                 NSThread *thread = [NSThread currentThread];
                 if (![thread isMainThread]) {
                     dispatch_sync(dispatch_get_main_queue(), ^(){
                         [_videoArr removeAllObjects];
                         [_videoArr addObject:outputURL];
                         [_tableView reloadData];
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                     });
                 }
             }
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
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

-(void)finishEdit:(NSString *)name price:(NSString *)price properties:(NSString *)properties headImageURL:(NSString *)headImageURL {
    _name = name;
    _price = price;
    _properties = properties;
    _avatar = headImageURL;
}


@end
