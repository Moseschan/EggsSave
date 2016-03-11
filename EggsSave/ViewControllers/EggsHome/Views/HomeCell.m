//
//  HomeCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "HomeCell.h"
#import "Masonry.h"
#import "CommonDefine.h"

@implementation HomeCell
{
    UIImageView* _iconImageView;
    UILabel*     _nameLabel;
    UILabel*     _detailLabel;
    UILabel*     _extendLabel;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIImageView* v1 = [[UIImageView alloc]init];
    v1.image = [UIImage imageNamed:@"goldicon"];
    [self.contentView addSubview:v1];
    _iconImageView = v1;
    
    UILabel* v2 = [[UILabel alloc]init];
    v2.text = @"赚钱";
    v2.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:v2];
    _nameLabel = v2;
    
    UILabel* v3 = [[UILabel alloc]init];
    v3.text = @"试玩应用赚现金";
    v3.font = [UIFont systemFontOfSize:15];
    v3.textColor = [UIColor grayColor];
    [self.contentView addSubview:v3];
    _detailLabel = v3;
    
    UILabel* v4 = [[UILabel alloc]init];
    v4.text = @"绑定手机号后,账号更安全!";
    v4.font = [UIFont systemFontOfSize:13];
    v4.textColor = [UIColor colorWithRed:245.f/255 green:166.f/255 blue:95.f/255 alpha:1];
    [self.contentView addSubview:v4];
    _extendLabel = v4;
    
//    right_arrow
    UIImageView* arrow = [[UIImageView alloc]init];
    arrow.image = [UIImage imageNamed:@"right_arrow"];
    [self.contentView addSubview:arrow];
    
    UIView* hLine = [[UIView alloc]init];
    hLine.backgroundColor = [UIColor colorWithRed:211.f/255 green:211.f/255 blue:211.f/255 alpha:1];
    [self.contentView addSubview:hLine];
    
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 1));
        make.left.bottom.equalTo(self.contentView);
    }];
    
    //添加约束
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(13);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.left.equalTo(_iconImageView.mas_right).offset(5);
        make.top.equalTo(self.contentView).offset(20);
        make.bottom.lessThanOrEqualTo(self.contentView).offset(-20);
    }];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_iconImageView);
        make.right.equalTo(self.contentView).offset(-35);
    }];
    
    [_extendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_detailLabel);
        make.top.equalTo(_detailLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-3);
    }];
    
}

- (void)setModel:(HomeModel *)model
{
    _model = model;
    
    _iconImageView.image = [UIImage imageNamed:_model.iconName];
    _nameLabel.text = _model.name;
    _detailLabel.text = _model.detail;
    _extendLabel.text = _model.extend;
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
