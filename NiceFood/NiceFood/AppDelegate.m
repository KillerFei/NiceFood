//
//  AppDelegate.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "AppDelegate.h"
#import "NFMainViewController.h"
#import "NFBaseNavigationController.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AdSupport/AdSupport.h>

@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIImageView *launchView;
@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setUpBaseNetwork];
    [self setUpUMClick];
    [self setUpKeyWindow];
    [self setUpLaunchView];
    [self checkUpVersion];
    
    return YES;
}
#pragma mark - setUpUMClick
- (void)setUpUMClick
{
    UMConfigInstance.appKey = kUMAppKey;
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick event:kNFFinishLaunch];
    
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUMAppKey];
    
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppId appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
}
#pragma mark - setUpLaunchAnim
- (void)setUpLaunchView
{
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage = nil;
    NSArray* imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary* dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    _launchView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:launchImage]];
    _launchView.frame = [UIScreen mainScreen].bounds;
    _launchView.contentMode = UIViewContentModeScaleAspectFill;
    
    CGFloat topHeight = KSCREEN_WIDTH*45/32.f;
    UIImageView *topView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nf_launch_top.jpg"]];
    topView.frame = CGRectMake(0, 0, KSCREEN_WIDTH, topHeight);
    topView.contentMode = UIViewContentModeScaleAspectFill;
    [_launchView addSubview:topView];
    [[UIApplication sharedApplication].keyWindow addSubview:_launchView];
}
- (void)removeLaunchView
{
    [UIView animateWithDuration:1.0f
                          delay:0.5f
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         _launchView.alpha = 0.0f;
                         _launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
                     }
                     completion:^(BOOL finished) {
                         [_launchView removeFromSuperview];
                         _launchView = nil;
                     }];
}
#pragma mark - setUpBaseNetwork
- (void)setUpBaseNetwork
{
  
    [HYBNetworking updateBaseUrl:kNFBaseHostUrl];                //默认hostUrl
    [HYBNetworking configRequestType:kHYBRequestTypePlainText       //请求类型 数据类型 Encode Url
                        responseType:kHYBResponseTypeJSON
                 shouldAutoEncodeUrl:YES
             callbackOnCancelRequest:NO];
    [HYBNetworking enableInterfaceDebug:YES];                        //是否开启debug模式
    [HYBNetworking obtainDataFromLocalWhenNetworkUnconnected:YES];  //网络异常时本地获取数据
    [HYBNetworking cacheGetRequest:YES shoulCachePost:YES];         //数据缓存
    [HYBNetworking setTimeout:20.f];                                //超时回调
}

- (void)setUpKeyWindow
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLaunchView) name:kNFRemoveLaunchViewNoti object:nil];
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NFMainViewController *rootVC = [[NFMainViewController alloc] init];
    NFBaseNavigationController *nav = [[NFBaseNavigationController alloc] initWithRootViewController:rootVC];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
}

- (void)checkUpVersion
{
    // 埋点  用户第一次安装时间
    NSString *firstVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kNFFirstVersionKey];
    if (kStringIsEmpty(firstVersion)) {
        [[NSUserDefaults standardUserDefaults] setObject:[NFOnlineManager currentVerson] forKey:kNFFirstVersionKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
//    if (![NFOnlineManager bUpdate]) return;
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName message:@"有新版本更新啦，更多功能等你来体验 ^_^" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
//    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    NSURL *updateUrl = [NSURL URLWithString:kAppUrl];
    [[UIApplication sharedApplication] openURL:updateUrl];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
