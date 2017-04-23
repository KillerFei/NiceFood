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
@property (nonatomic, strong) NFBaseModel *food;
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
- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"nf_love_delete"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
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
        [self.contentView addSubview:self.deleteBtn];
        [self setUpFrame];
    }
    return self;
}
- (void)setUpFrame
{
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
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.contentView).with.offset(0);
        make.right.equalTo(self.contentView).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}
#pragma mark - 配置数据
- (void)setUpModel:(NFBaseModel *)model;
{
    _food = model;
    [_imgView sd_setImageWithURL:[NSURL safeURLWithString:model.img_url]];
    _titleLabel.text = model.title;
    _desLabel.text = model.descrip;
}
- (void)prepareForReuse
{ 
    [super prepareForReuse];
    _food            = nil;
    _desLabel.text   = nil;
    _imgView.image   = nil;
    _titleLabel.text = nil;
}
#pragma mark - 长按删除状态
- (void)setUpLongGes
{
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGesAction:)];
    [self.contentView addGestureRecognizer:longGes];
}
- (void)longGesAction:(UILongPressGestureRecognizer *)ges
{
    if(ges.state == UIGestureRecognizerStateBegan) {
        if (_delegate && [_delegate respondsToSelector:@selector(beginDeleteState)]) {
            [_delegate beginDeleteState];
        }
    }
}
#pragma mark - 删除动作
- (void)deleteAction
{
    if (kObjectIsEmpty(_food) || kObjectIsEmpty(_indexPath)) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(deleteFood:atIndexpath:)]) {
        [_delegate deleteFood:_food atIndexpath:_indexPath];
    }
}
@end
