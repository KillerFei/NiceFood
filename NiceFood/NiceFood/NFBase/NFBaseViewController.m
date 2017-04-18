//
//  NFBaseViewController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFBaseViewController.h"

@interface NFBaseViewController ()

@end

@implementation NFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (!kStringIsEmpty(_navTitle)) {
        self.title = _navTitle;
    }
}
#pragma mark - hide NavBar
- (void)hideNavBar:(BOOL)isHide
{
    [self.navigationController setNavigationBarHidden:isHide];
}
#pragma mark - setLeftBackNavItem
- (void)setLeftBackNavItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 30);
    [btn setImage:[UIImage imageNamed:@"dt_nav_leftback"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}
#pragma mark - doBack
- (void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
