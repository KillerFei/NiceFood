//
//  NFHudManager.h
//  NiceFood
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFHudManager : NSObject

+ (void)showHudInView:(UIView *)view;
+ (void)showMessage:(NSString *)message InView:(UIView *)view;

+ (void)hideHudInView:(UIView *)view;
@end
