//
//  NFNetManger.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFNetManger.h"
#import <AdSupport/AdSupport.h>

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
+ (void)getFoodsWithParam:(NSDictionary *)param
                 callBack:(callBack)callBack;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:[NFNetManger commonParameter]];
    [params setValuesForKeysWithDictionary:param];
    [HYBNetworking getWithUrl:kNFRecommendListUrl refreshCache:YES params:params success:^(id response) {
        
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
                if (kStringIsEmpty(model.page_url)) {
                    continue;
                }
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

+ (void)getTypesFoodsWithCallBack:(callBack)callBack
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithDictionary:[NFNetManger commonParameter]];
    [HYBNetworking getWithUrl:kNFTypeListUrl refreshCache:YES params:param success:^(id response) {
        
        NSString *result = [(NSDictionary *)response objectForKey:@"result"];
        if ([result isEqualToString:@"ok"]) {
            NSArray *data = [(NSDictionary *)response objectForKey:@"data"];
            NSMutableArray *types = [[NSMutableArray alloc] init];
            for (NSDictionary *type in data) {
                NFBaseModel *model = [NFBaseModel mj_objectWithKeyValues:type];
                if (kStringIsEmpty(model.mainId)) {
                    continue;
                }
                [types addObject:model];
            }
            if (callBack) {
                callBack(nil,types);
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
