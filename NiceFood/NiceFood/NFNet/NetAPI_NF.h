//
//  NetAPI_NF.h
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#ifndef NetAPI_NF_h
#define NetAPI_NF_h

#define kNFBaseHostUrl                  @"https://zaijiawan.com"
//主页面推荐接口
//https://zaijiawan.com/matrix_common/api/recipe/detailsbook?appname=zhaoshipudaquan&hardware=iphone&os=ios&page=1&udid=11718b175e736c47cf703a86f1ebf13b16ba6d41&version=2.1.1
#define kNFRecommendListUrl             @"https://zaijiawan.com/matrix_common/api/recipe/detailsbook"

//主页面分类接口
//https://zaijiawan.com/matrix_common/api/recipe/mainbook?appname=zhaoshipudaquan&hardware=iphone&info_flow_ad%3Dtrue=true&os=ios&udid=11718b175e736c47cf703a86f1ebf13b16ba6d41&version=2.1.1
#define kNFTypeListUrl                   @"https://zaijiawan.com/matrix_common/api/recipe/mainbook"
//主页面广场分类接口
//http://api.jiefu.tv/app2/api/dt/shareItem/getByTag.html?tagId=5&pageNum=0&pageSize=48
#define kDTGetByTagUrl                  @"app2/api/dt/shareItem/getByTag.html"
//主页面制作接口
//http://api.jiefu.tv/app2/api/dt/item/recommendList.html?pageNum=0&pageSize=48
#define kDTRecommendListUrl             @"app2/api/dt/item/recommendList.html"

//制作编辑接口
//http://api.jiefu.tv/app2/api/dt/item/getDetail.html?itemId=7141
#define kDTGetDetailUrl                 @"app2/api/dt/item/getDetail.html"

//分类总接口
//http://api.jiefu.tv/app2/api/dt/tag/allList.html
#define kDTAllListUrl                   @"app2/api/dt/tag/allList.html"


#endif /* NetAPI_NF_h */
