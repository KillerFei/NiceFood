//
//  NFWebViewController.h
//  NiceFood
//
//  Created by yuepengfei on 17/4/19.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFBaseViewController.h"

@interface NFWebViewController : NFBaseViewController

@property (nonatomic, strong) NSString *mainId;
@property (nonatomic, strong) NSNumber *fid;
@property (nonatomic, strong) NSString *pageUrl;

@property (nonatomic, strong) NFBaseModel *food;

@end
