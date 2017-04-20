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
@property (nonatomic, strong) UIButton  *collectBtn;

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
    [NFDBManager runBlockInBackground:^{
        _colletFoods =  [[NFDBManager shareInstance] getFoods];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            for (NFBaseModel *food in _colletFoods) {
                if ([food.page_url isEqualToString:_food.page_url]) {
                    
                    _collectBtn.userInteractionEnabled = NO;
                    break;
                }
            }
        });
    }];
}
#pragma mark - setRightNavItem
- (void)setRightNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setImage:[UIImage imageNamed:@"nf_nav_leftback"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(collectFood) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
#pragma marl - collectFood
- (void)collectFood
{
    [[NFDBManager shareInstance] saveFood:_food];
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
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - webViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [NFHudManager showHudInView:self.view];
}
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
