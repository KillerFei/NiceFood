//
//  NFCollectViewController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFCollectViewController.h"
#import "NFWebViewController.h"
#import "NFCollectionViewCell.h"

@interface NFCollectViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, NFCollectionViewCellDelegate>
{
    BOOL _deleteFlag;
    BOOL _firstLoad;
}
@property (nonatomic, strong) UIView                 *noResultView;
@property (nonatomic, strong) UICollectionView       *myView;
@property (nonatomic, strong) NSMutableArray         *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@end

@implementation NFCollectViewController

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
        _myView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) collectionViewLayout:layOut];
        _myView.backgroundColor = NF_Base_BgGrayColor;
        [_myView registerClass:[NFCollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
        _myView.delegate = self;
        _myView.dataSource = self;
    }
    return _myView;
}
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
- (UIView *)noResultView
{
    if (!_noResultView) {
        _noResultView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64)];
        UIImageView *noReultImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nf_noLiked"]];
        noReultImg.center = CGPointMake(KSCREEN_WIDTH/2, (KSCREEN_HEIGHT-204)/2);
        [_noResultView addSubview:noReultImg];
    }
    return _noResultView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpFlag];
    [self setUpTapGes];
    [self setUpTabView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [NFDBManager runBlockInBackground:^{
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:[[NFDBManager shareInstance] getFoods]];
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self addNoResultView];
             [self removeNoResultView];
             if (_firstLoad && self.dataSource.count > 0) {
                 [self.myView reloadData];
             }
             _firstLoad = YES;
         });
    }];
}
- (void)addNoResultView
{
    if (kArrayIsEmpty(self.dataSource)) {
        [self.view addSubview:self.noResultView];
    }
}
- (void)removeNoResultView
{
    if (!kArrayIsEmpty(self.dataSource)) {
        if (_noResultView && [_noResultView superview]) {
            [_noResultView removeFromSuperview];
            _noResultView = nil;
        }
    }
}
#pragma mark - 初始化标记
- (void)setUpFlag
{
    _firstLoad  = NO;
    _deleteFlag = NO;
}
#pragma mark - 配置手势
- (void)setUpTapGes
{
    _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    _tapGes.enabled = NO;
    [self.view addGestureRecognizer:_tapGes];
}
- (void)tapAction
{
    [self exitDeleteState];
}
#pragma mark - setUpTabView
- (void)setUpTabView
{
    [self.view addSubview:self.myView];
}
#pragma mark - CollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [cell setUpLongGes];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NFCollectionViewCell *collectCell = (NFCollectionViewCell *)cell;
    collectCell.delegate = self;
    [collectCell setUpModel:self.dataSource[indexPath.item]];
    [self setVisibleCell:(NFCollectionViewCell *)cell indexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (_deleteFlag) {
        [self exitDeleteState];
        return;
    }
    NFBaseModel *baseModel = self.dataSource[indexPath.item];
    NFWebViewController *webVC = [[NFWebViewController alloc] init];
    webVC.navTitle = baseModel.title;
    webVC.pageUrl  = baseModel.page_url;
    webVC.food     = baseModel;
    [MobClick event:KNFCollectViewClick];
    [self.navigationController pushViewController:webVC animated:YES];
}
#pragma mark -  添加动画
- (void)setVisibleCell:(NFCollectionViewCell *)cell
                indexPath:(NSIndexPath *)indexPath
{
    cell.delegate  = self;
    cell.indexPath = indexPath;
    cell.deleteBtn.hidden = _deleteFlag?NO:YES;
    if (_deleteFlag) {
        [self addAnimationForCell:cell];
    }else{
        [cell.layer removeAnimationForKey:@"shake"];
    }
}
- (void)addAnimationForCell:(NFCollectionViewCell *)cell
{
    CAKeyframeAnimation *rvibrateAni = [CAKeyframeAnimation animation];
    rvibrateAni.keyPath = @"transform.rotation";
    CGFloat angle = M_PI_4/18;
    rvibrateAni.values = @[@(-angle),@(angle),@(-angle)];
    rvibrateAni.repeatCount = MAXFLOAT;
    [cell.layer addAnimation:rvibrateAni forKey:@"shake"];
}
#pragma mark - 退出删除模式
- (void)exitDeleteState
{
    _deleteFlag = NO;
    _tapGes.enabled = NO;
    [self.myView reloadData];
}
#pragma mark - 进入删除模式
- (void)beginDeleteState
{
    _deleteFlag = YES;
    _tapGes.enabled = YES;
    [self.myView reloadData];
}
#pragma mark - 删除菜谱
- (void)deleteFood:(NFBaseModel *)food
       atIndexpath:(NSIndexPath *)indexPath
{
    [NFDBManager runBlockInBackground:^{
        [[NFDBManager shareInstance] deleteFood:food];
    }];
    [MobClick event:KNFCancleLoveClick_Collect];
    [self.myView performBatchUpdates:^{
        [self.dataSource removeObject:food];
        [self.myView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        if (self.dataSource.count == 0) {
            _deleteFlag = NO;
            _tapGes.enabled = NO;
            [self addNoResultView];
            [NFHudManager showMessage:@"取消收藏成功" InView:self.view];
        }
        [self.myView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
