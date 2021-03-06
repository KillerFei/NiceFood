//
//  NFCollectionViewCell.h
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NFCollectionViewCell;

@protocol NFCollectionViewCellDelegate <NSObject>

- (void)beginDeleteState;
- (void)deleteFood:(NFBaseModel *)food
       atIndexpath:(NSIndexPath *)indexPath;
@end

@interface NFCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIButton    *deleteBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) id<NFCollectionViewCellDelegate>delegate;

- (void)setUpLongGes;
- (void)setUpModel:(NFBaseModel *)model;
@end
