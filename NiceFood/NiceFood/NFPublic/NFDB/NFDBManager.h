//
//  NFDBManager.h
//  NiceFood
//
//  Created by yuepengfei on 17/4/20.
//  Copyright © 2017年 fly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFDBManager : NSObject

+ (instancetype)shareInstance;
// 保存
- (BOOL)saveFood:(NFBaseModel *)food;
// 删除
- (BOOL)deleteFood:(NFBaseModel *)food;
// 获取
- (NSArray *)getFoods;

+ (void)runBlockInBackground:(void (^)())block;

@end
