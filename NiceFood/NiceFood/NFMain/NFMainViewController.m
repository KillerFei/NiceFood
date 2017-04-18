//
//  NFMainViewController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFMainViewController.h"
#import "NFRecommendViewController.h"
#import "NFTypeViewController.h"
#import "NFCollectViewController.h"

@interface NFMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView   *mainScr;
@property (nonatomic, strong) NSMutableArray *btnArr;
@property (nonatomic, strong) UIButton       *currentBtn;
@end
@implementation NFMainViewController

- (NSMutableArray *)btnArr
{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpChildVC];
    [self setUpTitleView];
}
#pragma mark - setUpChildVC
- (void)setUpChildVC
{
    _mainScr = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64)];
    _mainScr.delegate = self;
    _mainScr.pagingEnabled = YES;
    _mainScr.showsVerticalScrollIndicator = NO;
    _mainScr.showsHorizontalScrollIndicator = NO;
    _mainScr.contentSize = CGSizeMake(KSCREEN_WIDTH*3, 0);
    [self.view addSubview:_mainScr];
    
    NFRecommendViewController *reVC = [[NFRecommendViewController alloc] init];
    [self addChildViewController:reVC];
    reVC.view.frame = CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64);
    [_mainScr addSubview:reVC.view];
    
    NFTypeViewController *typeVC = [[NFTypeViewController alloc] init];
    [self addChildViewController:typeVC];
    typeVC.view.frame = CGRectMake(KSCREEN_WIDTH, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64);
    [_mainScr addSubview:typeVC.view];
    
    NFCollectViewController *collectVC = [[NFCollectViewController alloc] init];
    [self addChildViewController:collectVC];
    collectVC.view.frame = CGRectMake(KSCREEN_WIDTH*2, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT-64);
    [_mainScr addSubview:collectVC.view];
}
#pragma mark - setUpTitleView
- (void)setUpTitleView
{
    CGFloat width = KSCREEN_WIDTH-140;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44)];
    for (int i = 0; i < 3; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 10000+i;
        btn.titleLabel.font = NF_Nav_TitleFont;
        btn.frame = CGRectMake(i*(width/3), 0, width/3, 44);
        [btn setTitleColor:NF_Nav_TitleColor forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        switch (i) {
            case 0:
                [btn setTitle:@"推荐" forState:UIControlStateNormal];
                btn.userInteractionEnabled = NO;
                btn.titleLabel.font = NF_Nav_Title_BoldFont;
                _currentBtn = btn;
                break;
            case 1:
                [btn setTitle:@"分类" forState:UIControlStateNormal];
                break;
            case 2:
                [btn setTitle:@"收藏" forState:UIControlStateNormal];
                break;
        }
        [self.btnArr addObject:btn];
        [titleView addSubview:btn];
    }
    self.navigationItem.titleView = titleView;
}
#pragma mark - btnAction
- (void)btnAction:(UIButton *)sender
{
    NSInteger index = sender.tag-10000;
    [_mainScr setContentOffset:CGPointMake(KSCREEN_WIDTH*index, 0) animated:YES];
    [self setUpCurrentBtn:sender];
}
#pragma mark - setUpSeletBtn
- (void)setUpCurrentBtn:(UIButton *)btn
{
    [UIView animateWithDuration:2 animations:^{
       
        _currentBtn.userInteractionEnabled = YES;
        _currentBtn.titleLabel.font = NF_Nav_TitleFont;
        _currentBtn = btn;
        _currentBtn.userInteractionEnabled = NO;
        _currentBtn.titleLabel.font = NF_Nav_Title_BoldFont;
    }];
}
#pragma mark - ScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x/KSCREEN_WIDTH;
    UIButton *btn = [self.btnArr objectAtIndex:index];
    [self setUpCurrentBtn:btn];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}
@end
