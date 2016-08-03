//
//  CFUserViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/7/27.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFAdminMainViewController.h"
#import "CFLoginManager.h"
#import "CFUserManager.h"
#import "CFMainCollectionCellCollectionViewCell.h"
#import "CFCollectionViewFlowLayout.h"
#import "XWDragCellCollectionView.h"
#import "CFThemeManager.h"
#import "CFChangeBKImageViewController.h"
#import "CFAddCoffeeViewController.h"

@interface CFAdminMainViewController ()<XWDragCellCollectionViewDataSource,XWDragCellCollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    XWDragCellCollectionView *_colllectionview;
    UIPageControl *_pageControl;
    NSUInteger _countPage;
    CFCollectionViewFlowLayout *_layout;
}
@property (nonatomic, strong) NSArray *data;
@property (nonatomic,weak) UIImageView *BKImageView; //背景图
@end

@implementation CFAdminMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllCoffee];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeBK) name:kChangeApplicationBK object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_coffee"] style:UIBarButtonItemStylePlain target:self action:@selector(addMore)];
    
    UIImageView *BKImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *BKImage = [[CFThemeManager manager] currentBKImage];
    BKImageView.image = BKImage;
    self.BKImageView = BKImageView;
    [self.view addSubview:BKImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollection) name:kAddCoffeeSuccess object:nil];
}

//添加完咖啡 重载collection
- (void)reloadCollection {
    [CFDB getAllCoffee:^(BOOL succee, NSArray *coffees) {
        if (succee) {
            _data = [coffees copy];
            [self config];
        }
    }];
}

- (void)getAllCoffee {
    [CFDB getAllCoffee:^(BOOL succee, NSArray *coffees) {
        if (succee) {
            _data = [coffees copy];
            [self initUI];
        }
    }];
}

- (void)initUI {
    
    UILabel *label1 = [UILabel new];
    label1.font = [UIFont fontWithName:@"HelveticaNeue" size:20.f];
    label1.textColor = [UIColor colorWithHexString:@"BA6D89"];
    label1.text = @"Enjoy coffee time";
    [self.view addSubview:label1];
    
    UILabel *label2 = [UILabel new];
    label2.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50.f];
    label2.textColor = [UIColor whiteColor];
    label2.text = @"Choose your coffee";
    [self.view addSubview:label2];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(155);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(label1.mas_bottom).mas_offset(8);
    }];
    
    
    _layout = [CFCollectionViewFlowLayout new];
    [_layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    _colllectionview = [[XWDragCellCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_layout];
    _colllectionview.backgroundColor = [UIColor clearColor];
    _colllectionview.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
    _colllectionview.delegate = self;
    _colllectionview.dataSource = self;
    _colllectionview.shakeLevel = 5.0f;
    _colllectionview.pagingEnabled = YES;
    _colllectionview.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview:_colllectionview];
    [_colllectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(172);
        make.right.mas_equalTo(-172);
        make.top.mas_equalTo(label2.mas_bottom).mas_offset(36);
        make.height.mas_equalTo(400);
        make.width.mas_equalTo(kApplicationWidth-344);
    }];
    
    [_colllectionview registerClass:[CFMainCollectionCellCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    _pageControl = [UIPageControl new];
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_colllectionview);
        make.top.mas_equalTo(_colllectionview.mas_bottom).mas_offset(20);
    }];
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"422902"];
    _pageControl.currentPage = 0;
    
    [self config];
}

- (void)config {
    _countPage = [self numberOfPages];
    _pageControl.numberOfPages = _countPage;
    _layout.contentSizeWidth = (kApplicationWidth-344)*_countPage;
    [_colllectionview reloadData];
}

- (void)addMore {
    CFAddCoffeeViewController *addVC = [[CFAddCoffeeViewController alloc] initWithIndex:_data.count];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)setting {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Coffee" message:@"设置" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"切换用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CFLoginManager manager] logout];
    }];
    UIAlertAction *changeBKImage = [UIAlertAction actionWithTitle:@"设置背景图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CFChangeBKImageViewController *vc = [[CFChangeBKImageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [alertController addAction:archiveAction];
    [alertController addAction:changeBKImage];
    UIPopoverPresentationController *popVC = [alertController popoverPresentationController];
    popVC.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UICollectionViewDatasouce
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.data.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CFMainCollectionCellCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell configCell:self.data[indexPath.row]];
    return cell;
}

-(NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView {
    return self.data;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(130, 180);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 40.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 40.f;
}

#pragma mark - <XWDragCellCollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CFAddCoffeeViewController *addVC = [[CFAddCoffeeViewController alloc] initWithIndex:_data.count];
    [self.navigationController pushViewController:addVC animated:YES];
    
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray {
    _data = newDataArray;
}

/**
 *  cell移动完毕，并成功移动到新位置的时候调用 这时候 更新数据库
 */
- (void)dragCellCollectionViewCellEndMoving:(XWDragCellCollectionView *)collectionView {
    NSLog(@"1");
    //更新coffee
    for (CFCoffeeModel *model in _data) {
        NSInteger index = [_data indexOfObject:model];
        model.index = index;
    }
    [CFDB updateCoffee:_data finish:^(BOOL success) {
        if (success) {
            NSLog(@"更新成功");
        }else{
            NSLog(@"更新失败");
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageControl.currentPage = index;
}

// 计算当前页数
- (NSUInteger)numberOfPages {
    NSUInteger count = self.data.count;
    NSUInteger countPage = count/8;
    if (count%8!=0) {
        countPage+=1;
    }
    return countPage;
}

//改变背景
- (void)changeBK {
    UIImage *BKImage = [[CFThemeManager manager] currentBKImage];
    self.BKImageView.image = BKImage;
}

@end