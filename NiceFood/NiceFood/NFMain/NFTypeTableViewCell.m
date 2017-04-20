//
//  NFTypeTableViewCell.m
//  NiceFood
//
//  Created by 岳鹏飞 on 2017/4/18.
//  Copyright © 2017年 fly. All rights reserved.
//

#import "NFTypeTableViewCell.h"

@interface NFTypeTableViewCell ()

@property (nonatomic, strong) UIView      *bgView;
@property (nonatomic, strong) UIImageView *imgView;
@end
@implementation NFTypeTableViewCell
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.backgroundColor = NF_Base_BgGrayColor;
    }
    return _imgView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = NF_Base_BgGrayColor;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.imgView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).with.offset(5);
        make.bottom.equalTo(self.contentView).with.offset(-5);
        make.left.equalTo(self.contentView).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(10);
        make.bottom.equalTo(self.contentView).with.offset(-10);
        make.left.equalTo(self.contentView).with.offset(15);
        make.right.equalTo(self.contentView).with.offset(-15);
    }];
}
- (void)configModel:(NFBaseModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL safeURLWithString:model.img_url]];
}
@end
