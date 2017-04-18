//
//  NFCollectionViewCell.m
//  ReDouCartoon
//
//  Created by yuepengfei on 17/4/18.
//  Copyright © 2017年 BF_Soft. All rights reserved.
//

#import "NFCollectionViewCell.h"

@interface NFCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *lineView;
@property (nonatomic, strong) UILabel     *desLabel;
@end
@implementation NFCollectionViewCell
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font      = NF_Base_TitleFont;
        _titleLabel.textColor = NF_Base_TitleColor;
    }
    return _titleLabel;
}
- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = NF_Base_LineColor;
    }
    return _lineView;
}
- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = NF_Base_ContentFont;
        _desLabel.textColor = NF_Base_ContentColor;
    }
    return _desLabel;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.desLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(@(CGRectGetHeight(self.contentView.frame)-60));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_imgView.mas_bottom);
        make.left.equalTo(self.contentView).with.offset(5);
        make.right.equalTo(self.contentView).with.offset(-5);
        make.height.mas_equalTo(@30);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_titleLabel.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.height.mas_equalTo(@1);
    }];
    
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_lineView.mas_bottom);
        make.left.equalTo(_titleLabel.mas_left);
        make.right.equalTo(_titleLabel.mas_right);
        make.bottom.equalTo(self.contentView);
    }];
}
- (void)configModel:(NFBaseModel *)model
{
    [_imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url]];
    _titleLabel.text = model.title;
    _desLabel.text = model.descrip;
}
@end
