//
//  NFNetManger.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFNetManger.h"
#import <AdSupport/AdSupport.h>
#import "NetAPI_NF.h"

@implementation NFNetManger

+ (NSDictionary *)commonParameter
{
    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    adId = [adId stringByReplacingOccurrencesOfString:@"-" withString:@""];
    if (kStringIsEmpty(adId)) {
        adId = @"xxxx";
    }
    NSDictionary *param = @{@"appname":@"zhaoshipudaquan",
                            @"hardware":@"iphone",
                            @"os":@"ios",
                            @"udid":adId,
                            @"version":@"2.1.1"};
    return param;
}
+ (void)getRecommendFoodsWithPage:(NSInteger)page
                         callBack:(callBack)callBack
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:[NFNetManger commonParameter]];
    [param setObject:@(page) forKey:@"page"];
    [HYBNetworking getWithUrl:kNFRecommendListUrl refreshCache:YES params:param success:^(id response) {
        
        NSString *result = [(NSDictionary *)response objectForKey:@"result"];
        if ([result isEqualToString:@"ok"]) {
            NSDictionary *data = [(NSDictionary *)response objectForKey:@"data"];
            NSArray *recipes = data[@"recipes"];
            [NFBaseModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
                return @{@"fid":@"id",
                         @"descrip":@"description"};
            }];
            NSMutableArray *foots = [[NSMutableArray alloc] init];
            for (NSDictionary *foot in recipes) {
                NFBaseModel *model = [NFBaseModel mj_objectWithKeyValues:foot];
                [foots addObject:model];
            }
            if (callBack) {
                callBack(nil,foots);
            }
        } else {
            if (callBack) {
                callBack(nil,nil);
            }
        }
    } fail:^(NSError *error) {
        if (callBack) {
            callBack(nil,nil);
        }
    }];
}

@end
