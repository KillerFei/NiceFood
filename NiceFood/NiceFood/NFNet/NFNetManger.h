//
//  NFNetManger.h
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^callBack)(NSError *error ,NSArray *foods);

@interface NFNetManger : NSObject

+ (void)getRecommendFoodsWithPage:(NSInteger)page
                        callBack:(callBack)callBack;

@end
