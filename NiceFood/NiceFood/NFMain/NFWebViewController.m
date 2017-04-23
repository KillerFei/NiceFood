//
//  NFWebViewController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFWebViewController.h"

@interface NFWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSArray   *colletFoods;
@end

@implementation NFWebViewController

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64)];
        _webView.scrollView.bounces = NO;
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
    }
    return _webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBackNavItem];
    [self setRightNavItem];
    [self setUpWebView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)refreshRightNavBtn:(UIButton *)btn
{
    [NFDBManager runBlockInBackground:^{
        _colletFoods =  [[NFDBManager shareInstance] getFoods];
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NFBaseModel *food in _colletFoods) {
                if ([food.page_url isEqualToString:_food.page_url]) {
                    btn.selected = YES;
                    break;
                }
            }
        });
    }];
}
#pragma mark - setRightNavItem
- (void)setRightNavItem
{
    UIButton *loveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loveBtn.frame = CGRectMake(0, 0, 35, 44);
    loveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 6.5, 0, -6.5);
    [loveBtn setImage:[UIImage imageNamed:@"nf_love_selete"] forState:UIControlStateSelected];
    [loveBtn setImage:[UIImage imageNamed:@"nf_love_normal"] forState:UIControlStateNormal];
    [loveBtn addTarget:self action:@selector(loveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(35, 0, 35, 44);
    shareBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
    [shareBtn setImage:[UIImage imageNamed:@"nf_share_bg"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];

    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [toolBar addSubview:loveBtn];
    [toolBar addSubview:shareBtn];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolBar];
    
    [self refreshRightNavBtn:loveBtn];
}
#pragma marl - btnAction
- (void)loveBtnAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [NFDBManager runBlockInBackground:^{
            [[NFDBManager shareInstance] saveFood:_food];
            dispatch_async(dispatch_get_main_queue(), ^{
                [NFHudManager showMessage:@"收藏成功" InView:self.view];
            });
        }];
    } else {
        [NFDBManager runBlockInBackground:^{
            [[NFDBManager shareInstance] deleteFood:_food];
            dispatch_async(dispatch_get_main_queue(), ^{
                [NFHudManager showMessage:@"取消收藏" InView:self.view];
            });
        }];
    }
}
- (void)shareBtnAction:(UIButton *)sender
{
    NSLog(@"++++++++++++++++");
}
#pragma mark - setUpWebView
- (void)setUpWebView
{
    [self.view addSubview:self.webView];
    NSString *str = nil;
    if (!kStringIsEmpty(_pageUrl)) {
        str = _pageUrl;
    } else {
        str = [NSString stringWithFormat:@"http://zaijiawan.com/matrix_common/CookBook.jsp?mainId=%@&id=%@",_mainId,_fid];
    }
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    [NFHudManager showHudInView:self.view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [NFHudManager hideHudInView:self.view];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [NFHudManager hideHudInView:self.view];
    [NFHudManager showMessage:@"网络错误" InView:self.view];
}
@end
