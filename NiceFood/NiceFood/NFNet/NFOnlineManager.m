//
//  NFOnlineManager.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFOnlineManager.h"

@implementation NFOnlineManager
//检查更新
+ (BOOL)bUpdate
{
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:kDTLastVersionKey];
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


@end
