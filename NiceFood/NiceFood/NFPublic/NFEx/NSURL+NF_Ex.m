//
//  NSURL+NF_Ex.m
//  NiceFood
//
//  Created by 岳鹏飞 on 2017/4/20.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NSURL+NF_Ex.h"

@implementation NSURL (NF_Ex)

+ (NSURL *)safeURLWithString:(NSString *)URLString
{
    if (kStringIsEmpty(URLString)) {
        return nil;
    }
    NSString *encodeStr = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [NSURL URLWithString:encodeStr];
}
@end
