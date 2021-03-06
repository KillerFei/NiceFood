//
//  NFRecommendViewController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFRecommendViewController.h"
#import "NFWebViewController.h"
#import "NFCollectionViewCell.h"

@interface NFRecommendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView      *launchView;
@property (nonatomic, strong) UICollectionView *myView;
@property (nonatomic, strong) NSMutableArray   *reFoods;
@property (nonatomic, assign) NSInteger        page;
@property (nonatomic, assign) BOOL             firstLoad;
@property (nonatomic, strong) UIView           *noResultView;
@end

@implementation NFRecommendViewController

- (UICollectionView *)myView
{
    if (!_myView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (KSCREEN_WIDTH-NF_Base_Space*3)/2;
        CGFloat imgHeight = 4/3*itemWidth;
        layOut.itemSize = CGSizeMake(itemWidth, imgHeight+60);
        layOut.minimumLineSpacing = NF_Base_Space;
        layOut.minimumInteritemSpacing = NF_Base_Space;
        layOut.sectionInset = UIEdgeInsetsMake(NF_Base_Space, NF_Base_Space, NF_Base_Space, NF_Base_Space);
        if (kStringIsEmpty(_mainId)) {
            _myView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) collectionViewLayout:layOut];
        } else {
            _myView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) collectionViewLayout:layOut];
        }
        _myView.backgroundColor = NF_Base_BgGrayColor;
        [_myView registerClass:[NFCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        _myView.delegate = self;
        _myView.dataSource = self;
    }
    return _myView;
}
- (NSMutableArray *)reFoods
{
    if (!_reFoods) {
        _reFoods = [[NSMutableArray alloc] init];
    }
    return _reFoods;
}
- (UIView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64)];
        UIImageView *noReultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nf_net_faild"]];
        noReultImg.center = CGPointMake(KSCREEN_WIDTH/2, (KSCREEN_HEIGHT-204)/2);
        noReultImg.userInteractionEnabled = YES;
        [_noResultView addSubview:noReultImg];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_noResultView addGestureRecognizer:tap];
    }
    return _noResultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTabView];
    [self requestData];
}
#pragma mark - setUpTabView
- (void)setUpTabView
{
    _page = 1;
    [self.view addSubview:self.myView];
    if (!kStringIsEmpty(_mainId)) {
        [self setLeftBackNavItem];
    }
    [self addRefreshHeader];
}
#pragma mark - Refresh and LoadMore
- (void)addRefreshHeader
{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    _myView.mj_header = header;
}
- (void)addLoadMoreFooter
{
    if (!_firstLoad) {
       
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _myView.mj_footer = footer;
        _firstLoad = YES;
    }
}
#pragma mark - loadNew
- (void)loadNewData
{
    _page = 1;
    [self requestData];
}
#pragma mark - loadMoreData
- (void)loadMoreData
{
    _page++;
    [self requestData];
}
#pragma mark - requestData
- (void)requestData
{
    NSDictionary *param = nil;
    if (!kStringIsEmpty(_mainId)) {
        param = @{@"page":@(_page), @"mainId":_mainId};
    } else {
        param = @{@"page":@(_page)};
    }
    if (!_firstLoad) {
        [NFHudManager showHudInView:self.view];
    }
    [NFNetManger getFoodsWithParam:param callBack:^(NSError *error, NSArray *foods) {
        
        if (!_firstLoad) {
            [NFHudManager hideHudInView:self.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNFRemoveLaunchViewNoti object:nil];
        }
        [self.myView.mj_header endRefreshing];
        [self.myView.mj_footer endRefreshing];
        if (!kArrayIsEmpty(foods)) {
            
            if (_page == 1) {
                [self.reFoods removeAllObjects];
            }
            [self.reFoods addObjectsFromArray:foods];
            [self.myView reloadData];
            [self addLoadMoreFooter];
            
        } else {
            if (kArrayIsEmpty(self.reFoods)) {
                [self.view addSubview:self.noResultView];
            }
            [self.myView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
#pragma mark - collectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.reFoods.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NFCollectionViewCell *rCell = (NFCollectionViewCell *)cell;
    [rCell setUpModel:self.reFoods[indexPath.item]];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NFBaseModel *baseModel = self.reFoods[indexPath.item];
    NFWebViewController *webVC = [[NFWebViewController alloc] init];
    webVC.navTitle = baseModel.title;
    if (kStringIsEmpty(_mainId)) {
       webVC.mainId   = @"19";
       [MobClick event:KNFRecommendViewClick];
    } else {
        webVC.mainId   = baseModel.mainId;
        [MobClick event:KNFTypeListFoodClick];
    }
    webVC.fid = baseModel.fid;
    webVC.food = baseModel;
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark - tapAction
- (void)tapAction
{
    _page = 1;
    [self removeNoResultView];
    [self requestData];
}
- (void)removeNoResultView
{
    if (_noResultView && [_noResultView superview]) {
        [_noResultView removeFromSuperview];
        _noResultView = nil;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
