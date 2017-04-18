//
//  NFTypeViewController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFTypeViewController.h"
#import "NFTypeTableViewCell.h"

@interface NFTypeViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTab;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation NFTypeViewController

- (UITableView *)myTab
{
    if (!_myTab) {
        _myTab = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        [_myTab registerClass:[NFTypeTableViewCell class] forCellReuseIdentifier:@"cellId"];
        _myTab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myTab.backgroundColor = NF_Base_BgGrayColor;
        _myTab.rowHeight = (KSCREEN_WIDTH-30)*11.f/20;
        _myTab.delegate = self;
        _myTab.dataSource = self;
    }
    return _myTab;
}
- (NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabView];
    [self requestData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - setUpTabView
- (void)setUpTabView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 5)];
    headView.backgroundColor = NF_Base_BgGrayColor;
    self.myTab.tableHeaderView = headView;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 5)];
    footView.backgroundColor = NF_Base_BgGrayColor;
    self.myTab.tableFooterView = footView;
    
     [self.view addSubview:self.myTab];
}
#pragma mark - requestData
- (void)requestData
{
    [NFNetManger getTypesFoodsWithCallBack:^(NSError *error, NSArray *foods) {
       
        if (!kArrayIsEmpty(foods)) {
            [self.dataArr removeAllObjects];
            [self.dataArr addObjectsFromArray:foods];
            [self.myTab reloadData];
        }
    }];
}
#pragma mark - tableView 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [(NFTypeTableViewCell *)cell configModel:self.dataArr[indexPath.row]];
}
@end
