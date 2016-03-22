//
//  HomeIncomeCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/4/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "HomeIncomeCell.h"
#import "Masonry.h"

@implementation HomeIncomeCell
{
    UIImageView* _coinIconView;
    UILabel*     _myMoneyLabel;
    UILabel*     _myTotalMoneyLabel;
    UILabel*     _todayIncomeLable;
    UILabel*     _todayTotalIncomeLabel;
    UILabel*     _todayStudentsLabel;
    UILabel*     _todayTotalStudentsLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIImageView* v1 = [[UIImageView alloc]init];
    v1.image = [UIImage imageNamed:@"coinicon"];
    [self.contentView addSubview:v1];
    _coinIconView = v1;
    
    UILabel* v2 = [[UILabel alloc]init];
    v2.textColor = [UIColor redColor];
    v2.font = [UIFont systemFontOfSize:14];
    v2.text = @"我的余额（元）";
    [self.contentView addSubview:v2];
    _myMoneyLabel = v2;
    
    UILabel* v3 = [[UILabel alloc]init];
    v3.textColor = [UIColor redColor];
    v3.font = [UIFont systemFontOfSize:36];
    v3.text = @"5.57";
    [self.contentView addSubview:v3];
    _myTotalMoneyLabel = v3;
    
    UILabel* v4 = [[UILabel alloc]init];
    v4.font = [UIFont systemFontOfSize:13];
    v4.text = @"今日收入（元）";
    [self.contentView addSubview:v4];
    _todayIncomeLable = v4;
    
    UILabel* v5 = [[UILabel alloc]init];
    v5.textColor = [UIColor redColor];
    v5.font = [UIFont systemFontOfSize:14];
    v5.text = @"0.04";
    [self.contentView addSubview:v5];
    _todayTotalIncomeLabel = v5;
    
    UILabel* v6 = [[UILabel alloc]init];
    v6.font = [UIFont systemFontOfSize:13];
    v6.text = @"今日收徒（人）";
    [self.contentView addSubview:v6];
    _todayStudentsLabel = v6;
    
    UILabel* v7 = [[UILabel alloc]init];
    v7.textColor = [UIColor redColor];
    v7.font = [UIFont systemFontOfSize:14];
    v7.text = @"0";
    [self.contentView addSubview:v7];
    _todayTotalStudentsLabel = v7;
    
    //添加约束
    [_coinIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(13);
    }];
    
    [_myMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_coinIconView.mas_right).with.offset(5);
        make.top.equalTo(_coinIconView);
    }];
    
    [_myTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_coinIconView).with.offset(5);
        make.top.equalTo(_coinIconView.mas_bottom).with.offset(8);
        
    }];
    
    [_todayTotalIncomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_right).with.offset(-60);
        make.top.equalTo(_myMoneyLabel.mas_bottom);
    }];
    
    [_todayIncomeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_todayTotalIncomeLabel.mas_left).offset(-10);
        make.top.equalTo(_todayTotalIncomeLabel);
    }];
    
    [_todayTotalStudentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_todayTotalIncomeLabel);
        make.top.equalTo(_todayTotalIncomeLabel.mas_bottom).offset(8);
    }];
    
    [_todayStudentsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_todayIncomeLable);
        make.top.equalTo(_todayIncomeLable.mas_bottom).offset(8);
        
        make.bottom.equalTo(self.contentView).offset(-5);
    }];
    
}

- (void)setModel:(HomeIncomeModel *)model
{
    _model = model;
    
    _myTotalMoneyLabel.text = model.myLeftMoney;
    _todayTotalIncomeLabel.text = model.todayIncome;
    _todayTotalStudentsLabel.text = model.todayStudents;
    
}

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
