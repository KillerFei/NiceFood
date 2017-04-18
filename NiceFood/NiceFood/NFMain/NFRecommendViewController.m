//
//  NFRecommendViewController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFRecommendViewController.h"
#import "NFCollectionViewCell.h"

@interface NFRecommendViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *myView;
@property (nonatomic, strong) NSMutableArray   *reFoods;
@end

@implementation NFRecommendViewController

- (UICollectionView *)myView
{
    if (!_myView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemWidth = (KSCREEN_WIDTH-NF_Base_Space*3)/2;
        CGFloat imgHeight = 66.5/50*itemWidth;
        layOut.itemSize = CGSizeMake(itemWidth, imgHeight+60);
        layOut.minimumLineSpacing = NF_Base_Space;
        layOut.minimumInteritemSpacing = NF_Base_Space;
        layOut.sectionInset = UIEdgeInsetsMake(NF_Base_Space, NF_Base_Space, NF_Base_Space, NF_Base_Space);
        _myView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layOut];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.myView];
    [self requestData];
}
#pragma mark - requestData
- (void)requestData
{
    [NFNetManger getRecommendFoodsWithPage:1 callBack:^(NSError *error, NSArray *foods) {
       
        if (!kArrayIsEmpty(foods)) {
            [self.reFoods addObjectsFromArray:foods];
            [self.myView reloadData];
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
    
    [rCell configModel:self.reFoods[indexPath.item]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
