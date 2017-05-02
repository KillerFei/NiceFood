//
//  NFOnlineManager.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFOnlineManager.h"

@interface NFOnlineManager ()<UIAlertViewDelegate>

@end

@implementation NFOnlineManager
//检查更新
+ (BOOL)bUpdate
{
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kNFLastVersionKey];
    if (!lastVersion) {
        return NO;
    }
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if ([lastVersion isEqualToString:currentVersion]) {
        return NO;
    }
    return YES;
}

+ (NSString *)currentVerson
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}
+ (void)gotoJudge
{
    NSString *version = [NFOnlineManager currentVerson];
    NSString *commentVer = [[NSUserDefaults standardUserDefaults] objectForKey:kNFVersionCommentKey];
    if ([commentVer isEqualToString:version]) {
        return;
    }
    NSInteger number = [[[NSUserDefaults standardUserDefaults] objectForKey:kNFReadFoodCount] integerValue];
    if (number < 15) {
        number++;
        [[NSUserDefaults standardUserDefaults] setObject:@(number) forKey:kNFReadFoodCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    NSString *message = [NSString stringWithFormat:@"亲，%@一直致力于做无如果您有为您带来方便，还请支持下我们^_^",kAppName];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    NSURL *commentUrl = [NSURL URLWithString:kAppUrl];
    [[UIApplication sharedApplication] openURL:commentUrl];
    NSString *version = [NFOnlineManager currentVerson];
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kNFVersionCommentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
