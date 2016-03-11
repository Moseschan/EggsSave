//
//  TixianMessageCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/7/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "TixianMessageCell.h"
#import "Masonry.h"

@implementation TixianMessageCell
{
    UIImageView* _iconImageView;
    UILabel*     _nameLabel;
    UILabel*     _timeLabel;
    UILabel*     _detailLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIView* bgView = [[UIView alloc]init];
    bgView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [self.contentView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
    UIImageView* v1 = [[UIImageView alloc]init];
    v1.image = [UIImage imageNamed:@"tou_01"];
    [bgView addSubview:v1];
    _iconImageView = v1;
    
    UILabel* v2 = [[UILabel alloc]init];
    v2.text = @"Diva";
    v2.font = [UIFont boldSystemFontOfSize:18];
    [bgView addSubview:v2];
    _nameLabel = v2;
    
    UILabel* v3 = [[UILabel alloc]init];
    v3.text = @"刚刚";
    v3.font = [UIFont systemFontOfSize:14];
    v3.textColor = [UIColor grayColor];
    [bgView addSubview:v3];
    _timeLabel = v3;
    
    UILabel* v4 = [[UILabel alloc]init];
    v4.text = @"通过支付宝提现100元";
    v4.numberOfLines = 0;
    v4.font = [UIFont systemFontOfSize:13];
    v4.textColor = [UIColor colorWithRed:245.f/255 green:166.f/255 blue:95.f/255 alpha:1];
    [bgView addSubview:v4];
    _detailLabel = v4;
    
    //添加约束
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(7);
        make.bottom.lessThanOrEqualTo(bgView).offset(-10);
        make.top.equalTo(bgView).offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(7);
        make.top.equalTo(bgView).offset(10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.left.equalTo(_nameLabel.mas_right).offset(7);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).offset(7);
        make.left.equalTo(_nameLabel);
        make.right.lessThanOrEqualTo(bgView).offset(-10);
        make.bottom.lessThanOrEqualTo(bgView).offset(-7);
    }];
    
}

- (void)setModel:(TiXianMessage *)model
{
    _model = model;
    
    _iconImageView.image = [UIImage imageNamed:_model.iconName];
    _nameLabel.text = _model.name;
    _detailLabel.text = _model.detail;
    _timeLabel.text = _model.time;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
