//
//  NFMenuViewController.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFMenuViewController.h"
#import "NFDisclaimerVC.h"
#import "NFMenuTableViewCell.h"
#import "NFMenuHeaderView.h"

typedef NS_ENUM(NSInteger, NFMenuType)
{
    kNFMenuType_Help,
    kNFMenuType_Declaration,
    kNFMenuType_Clear,
    kNFMenuType_Judge
};
@interface NFMenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView    *myTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end
static NSString *const kNFMenuCellIdentifier = @"myCellIdentifier";
@implementation NFMenuViewController
- (UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, KSCREEN_WIDTH, KSCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
        _myTableView.rowHeight = 55;
        _myTableView.delegate   = self;
        _myTableView.dataSource = self;
        _myTableView.backgroundColor = NF_Base_BgGrayColor;
        _myTableView.separatorColor = NF_Base_LineColor;
        [_myTableView registerClass:[NFMenuTableViewCell class] forCellReuseIdentifier:kNFMenuCellIdentifier];
        _myTableView.tableHeaderView = [[NFMenuHeaderView alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 180)];
    }
    return _myTableView;
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
    [self initItemMenu];
    [self setLeftBackNavItem];
    [self.view addSubview:self.myTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myTableView reloadData];
}

- (void)initItemMenu
{
    NSMutableArray *section = [[NSMutableArray alloc] init];
//    NSNumber *number = [NSNumber numberWithInteger:kNFMenuType_Help];
//    [section addObject:number];
    
    NSNumber *number = [NSNumber numberWithInteger:kNFMenuType_Judge];
    [section addObject:number];
    number = [NSNumber numberWithInteger:kNFMenuType_Declaration];
    [section addObject:number];
    [self.dataSource addObject:section];
    
    section = [[NSMutableArray alloc] init];
    number = [NSNumber numberWithInteger:kNFMenuType_Clear];
    [section addObject:number];
    [self.dataSource addObject:section];
}
#pragma mark - tableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kNFMenuCellIdentifier];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NFMenuTableViewCell *myCell = (NFMenuTableViewCell *)cell;
    myCell.titleLabel.textColor = NF_Base_TitleColor;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    myCell.cacheLabel.hidden = YES;
    NSArray *items = self.dataSource[indexPath.section];
    NSInteger item = [items[indexPath.row] integerValue];
    switch (item) {
        case kNFMenuType_Help:
            myCell.iconView.image = [UIImage imageNamed:@"dt_my_help"];
            myCell.titleLabel.text = @"使用帮助";
            break;
        case kNFMenuType_Clear:
            myCell.accessoryType = UITableViewCellAccessoryNone;
            myCell.iconView.image = [UIImage imageNamed:@"nf_menu_clear"];
            myCell.titleLabel.text = @"清除缓存";
            myCell.titleLabel.textColor = RGB(255, 47, 57);
            myCell.cacheLabel.hidden = NO;
            myCell.cacheLabel.text = [NSString stringWithFormat:@"%.02fM",[[SDImageCache sharedImageCache] getSize]/1024.f/1024];
            break;
        case kNFMenuType_Judge:
            myCell.iconView.image = [UIImage imageNamed:@"nf_menu_support"];
            myCell.titleLabel.text = @"给我们支持";
            break;
        case kNFMenuType_Declaration:
            myCell.iconView.image = [UIImage imageNamed:@"nf_menu_declare"];
            myCell.titleLabel.text = @"免责声明";
            break;
        default:
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *items = self.dataSource[indexPath.section];
    NSInteger item = [items[indexPath.row] integerValue];
    switch (item) {
        case kNFMenuType_Help:
            break;
        case kNFMenuType_Clear:
            [self clearCachesAtIndexPath:indexPath];
            break;
        case kNFMenuType_Judge:
            [self doJudge];
            break;
        case kNFMenuType_Declaration:
            [self showDeclaration];
            break;
        default:
            break;
    }
}
#pragma mark - private action
// 免责声明
- (void)showDeclaration
{
    NFDisclaimerVC *disVC = [[NFDisclaimerVC alloc] init];
    disVC.navTitle = @"免责声明";
    [self.navigationController pushViewController:disVC animated:YES];
}
// 清楚缓存
- (void)clearCachesAtIndexPath:(NSIndexPath *)indexpath
{
    [[SDImageCache sharedImageCache] clearDisk];
    NFMenuTableViewCell *myCell = [self.myTableView cellForRowAtIndexPath:indexpath];
    myCell.cacheLabel.text = @"0.00M";
    [NFHudManager showMessage:@"清除成功" InView:self.view];
}
// 给好评
- (void)doJudge
{
    NSURL *commentUrl = [NSURL URLWithString:kAppUrl];
    [[UIApplication sharedApplication] openURL:commentUrl];
    NSString *version = [NFOnlineManager currentVerson];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kNFVersionCommentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
