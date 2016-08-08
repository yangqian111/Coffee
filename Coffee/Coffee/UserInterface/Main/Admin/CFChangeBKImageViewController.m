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

@interface CFChangeBKImageViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UICollectionView *colllectionview;
@property (nonatomic,strong) NSArray *images;

@end

@implementation CFChangeBKImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _images = [[[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:@"Images"] copy];
    self.navigationItem.title = @"选择背景图片";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(250, 200);
    layout.minimumLineSpacing = 10.f;
    layout.minimumInteritemSpacing = 10.f;
    
    UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
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
