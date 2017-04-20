//
//  NFBaseModel.h
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NFBaseModel : NSObject

@property (nonatomic, strong) NSNumber *fid;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *descrip;
@property (nonatomic, strong) NSString *img_url;
@property (nonatomic, strong) NSString *page_url;

@property (nonatomic, strong) NSString *mainId;

@property (nonatomic, strong) NSDate   *joinDate;
@property (nonatomic, strong) NSString *reserve;

@end
