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
    [self setUpWebView];
}
#pragma mark - setUpWebView
- (void)setUpWebView
{
    [self setLeftBackNavItem];
    [self.view addSubview:self.webView];
    NSString *str = [NSString stringWithFormat:@"http://zaijiawan.com/matrix_common/CookBook.jsp?mainId=%@&id=%@",_mainId,_fid];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - webViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
