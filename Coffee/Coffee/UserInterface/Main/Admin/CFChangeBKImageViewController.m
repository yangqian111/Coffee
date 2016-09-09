//
//  CFChangeBKImageViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/8/2.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFChangeBKImageViewController.h"
#import "CFThemeManager.h"
#import "CFThemeManager.h"
#import "CFUserManager.h"

@interface CFChangeBKImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *colllectionview;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,weak) UITextField *firstTitle;
@property (nonatomic,weak) UITextField *secondTitle;

@end

@implementation CFChangeBKImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = [[[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:@"Images"] copy];
    self.navigationItem.title = @"选择背景图片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    
    UITextField *firstTitle = [UITextField new];
    firstTitle.leftView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 4, 10)];
    firstTitle.leftViewMode = UITextFieldViewModeAlways;
    firstTitle.background = [UIImage imageNamed:@"short_biankuang"];
    firstTitle.textColor = [UIColor blackColor];
    [self.view addSubview:firstTitle];
    
    self.firstTitle = firstTitle;
    NSString *firstTitleStr = [[CFUserManager manager] firstTitle];
    firstTitle.text = firstTitleStr;
    firstTitle.font = [UIFont systemFontOfSize:20];
    [firstTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
    
    UITextField *secondTitle = [UITextField new];
    secondTitle.leftView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, 4, 10)];
    secondTitle.leftViewMode = UITextFieldViewModeAlways;
    secondTitle.background = [UIImage imageNamed:@"short_biankuang"];
    firstTitle.textColor = [UIColor blackColor];
    [self.view addSubview:secondTitle];
    
    self.secondTitle = secondTitle;
    NSString *secondTitleStr = [[CFUserManager manager] secondTitle];
    secondTitle.text = secondTitleStr;
    secondTitle.font = [UIFont systemFontOfSize:30];
    [secondTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(firstTitle.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(40);
    }];
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(200, 150);
    layout.minimumLineSpacing = 50.f;
    layout.minimumInteritemSpacing = 50.f;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 200, kApplicationWidth-20, kApplicationHeight-230) collectionViewLayout:layout];
    collection.backgroundColor = [UIColor whiteColor];
    collection.contentInset = UIEdgeInsetsMake(20, 20, 20, 20);
    collection.delegate = self;
    collection.dataSource = self;
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
    [self.view addSubview:collection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pop {
    [[CFUserManager manager] setFirstTitle:self.firstTitle.text];
    [[CFUserManager manager] setSecondTitle:self.secondTitle.text];
    [EXCallbackHandle notify:kChangeApplicationTitle];
    [self popCurrentViewController];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _images.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIImage *image = [UIImage imageWithContentsOfFile:_images[indexPath.row]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = cell.contentView.frame;
    [cell.contentView addSubview:imageView];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *imageName = _images[indexPath.row];
    [[CFThemeManager manager] setCurrentBKImage:imageName];
    [EXCallbackHandle notify:kChangeApplicationBK];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
