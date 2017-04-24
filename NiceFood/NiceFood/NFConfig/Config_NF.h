//
//  Config_NF.h
//  NiceFood
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#ifndef Config_NF_h
#define Config_NF_h

#define kAppName                  @"美食菜谱大全"
#define kAppUrl                   @""
#define kUMAppKey                 @"58fd5b0a4ad1561acc00202e"

// key
#define kDTLastVersionKey         @"lastVersion"
#define kNFVersionCommentKey      @"versionCommentKey"
#define kNFRemoveLaunchViewNoti   @"removeLaunchViewNoti"

//----------------------UI类--------------------------
//RGB颜色
#define RGBA(r,g,b,a)              [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)                 RGBA(r,g,b,1.0f)

//Font字体
#define SYSTEM_FONT(F)             [UIFont systemFontOfSize:F]
#define BOLD_FONT(F)               [UIFont boldSystemFontOfSize:F]

#define NF_Base_Space              10.f

#define NF_Nav_TitleColor          [UIColor blackColor]
#define NF_Nav_TitleFont           SYSTEM_FONT(15)
#define NF_Nav_Title_BoldFont      BOLD_FONT(16)

#define NF_Base_TitleColor         RGB(106, 106, 106)
#define NF_Base_TitleFont          SYSTEM_FONT(15)

#define NF_Base_ContentColor       RGB(149, 149, 149)
#define NF_Base_ContentFont        SYSTEM_FONT(13)

#define NF_Base_BgGrayColor        RGB(241, 242, 243)
#define NF_Base_LineColor          RGB(225, 225, 225)
//----------------------设备类--------------------------
//获取屏幕 宽度、高度
#define KSCREEN_WIDTH              ([UIScreen mainScreen].bounds.size.width)
#define KSCREEN_HEIGHT             ([UIScreen mainScreen].bounds.size.height)

// iOS系统版本
#define IOSBaseVersion9     9.0
#define IOSBaseVersion8     8.0
#define IOSBaseVersion7     7.0

#define IOSCurrentBaseVersion ([[[UIDevice currentDevice] systemVersion] floatValue])

#define iOS9Later (IOSCurrentBaseVersion >= IOSBaseVersion9)
#define iOS8Later (IOSCurrentBaseVersion >= IOSBaseVersion8)
#define iOS7Later (IOSCurrentBaseVersion >= IOSBaseVersion7)

#define IPAD_DEVICE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//----------------------－引用－----------------------------
//Block
#define WS(weakSelf)            __weak   __typeof(&*self)weakSelf       = self

#define WeakSelf(weakSelf)      __weak   __typeof(&*self)weakSelf       = self
#define StrongSelf(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf


//----------------------数据判空----------------------------
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0 ? YES : NO)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))


// ===================== UM =====================
#define kNFFinishLaunch            @"KFinishLaunch"
#define kNFMenuBtnClick            @"KMenuBtnClick"
#define kNFSupportClick            @"KSupportClick"
#define kNFDeclareClick            @"KDeclareClick"
#define kNFClearCacheClick         @"KClearCacheClick"
#define kNFLoveBtnClick            @"KLoveBtnClick"
#define kNFCancleLoveClick         @"KCancelLoveClick"
#define KNFCancleLoveClick_Collect @"KCancelLoveClick_Collect"
#define KNFRecommendViewClick      @"KRecommendClick"
#define KNFTypeListViewClick       @"KTypeListViewClick"
#define KNFCollectViewClick        @"KCollectViewClick"
#define KNFFoodDetailViewShow      @"KFoodDetailShow"
#define KNFTypeListFoodClick       @"KTypeListFoodClick"

#endif /* Config_NF_h */
