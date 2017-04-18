//
//  NFBaseViewController.h
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NFBaseViewController : UIViewController

@property (nonatomic, strong) NSString *navTitle;

- (void)hideNavBar:(BOOL)isHide;
- (void)setLeftBackNavItem;
@end
