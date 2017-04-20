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
    BOOL deleteBtnFlag;
    BOOL vibrateAniFlag;
}
@property (nonatomic, strong) UICollectionView       *myView;
@property (nonatomic, strong) NSMutableArray         *dataSource;
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
@property (nonatomic, assign) BOOL                   firstLoad;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpFlag];
    [self setUpTapGes];
    [self setUpTabView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dataSource removeAllObjects];
    if (_firstLoad) {
        [self.myView reloadData];
    }
    _firstLoad = YES;
}
#pragma mark - setUpFlag
- (void)setUpFlag
{
    deleteBtnFlag = YES;
    vibrateAniFlag = YES;
}
#pragma mark - setUpTapGes
- (void)setUpTapGes
{
    _tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    _tapGes.enabled = NO;
    [self.view addGestureRecognizer:_tapGes];
}
- (void)tapAction
{
    [self hideAllDeleteBtn];
}
#pragma mark - setUpTabView
- (void)setUpTabView
{
    [self.view addSubview:self.myView];
}
#pragma mark - collectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[[NFDBManager shareInstance] getFoods] count];
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
    NSArray *foods = [[NFDBManager shareInstance] getFoods];
    [collectCell configModel:foods[indexPath.item]];
    [self setCellVibrate:(NFCollectionViewCell *)cell IndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (!vibrateAniFlag) {
        [self hideAllDeleteBtn];
        return;
    }
    NSArray *foods = [[NFDBManager shareInstance] getFoods];
    NFBaseModel *baseModel = foods[indexPath.item];
    NFWebViewController *webVC = [[NFWebViewController alloc] init];
    webVC.navTitle = baseModel.title;
    webVC.pageUrl = baseModel.page_url;
    webVC.food    = baseModel;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)setCellVibrate:(NFCollectionViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    
    cell.indexPath = indexPath;
    cell.deleteBtn.hidden = deleteBtnFlag?YES:NO;
    if (!vibrateAniFlag) {
        [self addAnimationForCell:cell];
    }else{
        [cell.layer removeAnimationForKey:@"shake"];
    }
    cell.delegate = self;
}
#pragma mark - addAnimationForCell 添加动画
- (void)addAnimationForCell:(NFCollectionViewCell *)cell
{
    CAKeyframeAnimation *rvibrateAni = [CAKeyframeAnimation animation];
    rvibrateAni.keyPath = @"transform.rotation";
    CGFloat angle = M_PI_4/18;
    rvibrateAni.values = @[@(-angle),@(angle),@(-angle)];
    rvibrateAni.repeatCount = MAXFLOAT;
    [cell.layer addAnimation:rvibrateAni forKey:@"shake"];
}
- (void)hideAllDeleteBtn{
    if (!deleteBtnFlag) {
        deleteBtnFlag = YES;
        vibrateAniFlag = YES;
        _tapGes.enabled = NO;
        [self.myView reloadData];
    }
}
- (void)showAllDeleteBtn{
    deleteBtnFlag = NO;
    vibrateAniFlag = NO;
    _tapGes.enabled = YES;
    [self.myView reloadData];
}
- (void)deleteFood:(NFBaseModel *)food
       atIndexpath:(NSIndexPath *)indexPath
{
    
    [self.myView performBatchUpdates:^{
        
        [[NFDBManager shareInstance] deleteFood:food];
        [self.myView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self.myView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
