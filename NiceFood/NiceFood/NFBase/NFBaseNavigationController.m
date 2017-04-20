//
//  NFBaseNavigationController.m
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFBaseNavigationController.h"

@implementation NFBaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor] , NSFontAttributeName:NF_Nav_Title_BoldFont}];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage imageNamed:@"dt_nav_bg"] stretchableImageWithLeftCapWidth:3 topCapHeight:3]  forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
}

@end
