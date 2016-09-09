//
//  CFUserMainViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/7/29.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFUserMainViewController.h"
#import "CFLoginManager.h"
#import "CFUserManager.h"
#import "CFMainCollectionCellCollectionViewCell.h"
#import "CFCoffeeModel.h"
#import "CFCollectionViewFlowLayout.h"
#import "CFThemeManager.h"
#import "CFUserCoffeeDetailViewController.h"

@interface CFUserMainViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    UIPageControl *_pageControl;
    NSUInteger _countPage;
}
@property (nonatomic, strong) NSArray *data;
@property (nonatomic,weak) UICollectionView *colllectionview;
@property (nonatomic,weak) UIImageView *BKImageView; //背景图

@end

@implementation CFUserMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllCoffee];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bottom_line"] forBarMetrics:UIBarMetricsCompact];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"setting"] style:UIBarButtonItemStylePlain target:self action:@selector(setting)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *BKImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *BKImage = [[CFThemeManager manager] currentBKImage];
    BKImageView.image = BKImage;
    self.BKImageView = BKImageView;
    [self.view addSubview:BKImageView];
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
    
    [self.view addSubview:label1];
    NSString *firstTitle = [[CFUserManager manager] firstTitle];
    label1.text = firstTitle;
    
    UILabel *label2 = [UILabel new];
    label2.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:50.f];
    label2.textColor = [UIColor whiteColor];
    [self.view addSubview:label2];
    
    NSString *secondTitle = [[CFUserManager manager] secondTitle];
    label2.text = secondTitle;
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(100);
    }];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(label1.mas_bottom).mas_offset(8);
    }];
    
    _countPage = [self numberOfPages];
    
    CFCollectionViewFlowLayout *layout = [CFCollectionViewFlowLayout new];
    layout.contentSizeWidth = (kApplicationWidth-74)*_countPage;;
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *colllectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.colllectionview = colllectionview;
    _colllectionview.contentInset = UIEdgeInsetsMake(0, 20, 0, 0);
    _colllectionview.backgroundColor = [UIColor clearColor];
    _colllectionview.delegate = self;
    _colllectionview.dataSource = self;
    _colllectionview.pagingEnabled = YES;
    _colllectionview.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_colllectionview];
    [_colllectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(47);
        make.right.mas_equalTo(-37);
        make.top.mas_equalTo(label2.mas_bottom).mas_offset(40);
        make.height.mas_equalTo(460);
        make.width.mas_equalTo(kApplicationWidth-84);
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
    _pageControl.numberOfPages = _countPage;
    _pageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setting {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"设置" preferredStyle: UIAlertControllerStyleActionSheet];
    UIAlertAction *archiveAction = [UIAlertAction actionWithTitle:@"切换用户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self willPresentAdminMainViewController];
    }];
    [alertController addAction:archiveAction];
    UIPopoverPresentationController *popVC = [alertController popoverPresentationController];
    popVC.barButtonItem = self.navigationItem.rightBarButtonItem;
    [self presentViewController: alertController animated: YES completion: nil];
}

- (void)willPresentAdminMainViewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入管理员密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入管理员密码";
    }];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *string = alert.textFields[0].text;
        if (![string  isEqualToString:@"admin"]) {
            [self.view makeToast:@"密码错误"];
        }else{
            [EXCallbackHandle notify: @"CFToAdmin"];
        }
    }];
    [alert addAction:cancle];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    CFCoffeeModel *model = _data[indexPath.row];
    CFUserCoffeeDetailViewController *vc = [[CFUserCoffeeDetailViewController alloc] initWithModel:model];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 220);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 40.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 20.f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int index = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    _pageControl.currentPage = index;
}

// 计算当前页数
- (NSUInteger)numberOfPages {
    NSUInteger count = self.data.count;
    NSUInteger countPage = count/10;
    if (count%10!=0) {
        countPage+=1;
    }
    return countPage;
}

@end
