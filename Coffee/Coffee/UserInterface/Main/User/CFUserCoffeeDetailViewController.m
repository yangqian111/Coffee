//
//  CFUserCoffeeDetailViewController.m
//  Coffee
//
//  Created by 羊谦 on 16/8/9.
//  Copyright © 2016年 yangqian. All rights reserved.
//

#import "CFUserCoffeeDetailViewController.h"
#import "CFCoffeeDetailTableViewCell.h"
#import "CFCoffeeModel.h"

@interface CFUserCoffeeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) CFCoffeeModel *model;

@end

@implementation CFUserCoffeeDetailViewController

- (instancetype)initWithModel:(CFCoffeeModel *)model {
    self = [super init];
    if (self) {
        _model = model;
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
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [self.tableView registerClass:[CFCoffeeDetailTableViewCell class] forCellReuseIdentifier:@"cellReuser"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(popCurrentViewController)];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CFCoffeeDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuser" forIndexPath:indexPath];
    [cell configModel:_model];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
