//
//  SKSSubTableViewCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "SKSSubTableViewCell.h"
#import "CommonDefine.h"
#import "Masonry.h"

@implementation QuestionModel

@end

@implementation SKSSubTableViewCell
{
    UIView*  _topView;
    
    UILabel* _titleView;
    UILabel* _detailView;
    
    BOOL     _isExpanded;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
        
//        if (self.gestureRecognizers.count == 0) {
//            UITapGestureRecognizer * gestureClicked = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelected)];
//            [self addGestureRecognizer:gestureClicked];
//        }
        
        _isExpanded = NO;
    }
    
    return self;
}

- (void)didSelected
{
    _isExpanded = !_isExpanded;
    
    if (_isExpanded) {
        _detailView.text = _model.q_details;
        
        if (self.block) {
            self.block();
        }
        
        [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).offset(10);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(-10);
        }];
    }else
    {
        _detailView.text = nil;
        
        if (self.block) {
            self.block();
        }
        
        [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_topView.mas_bottom).offset(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(0);
        }];
    }
    
    
}

- (void)setup
{
    self.contentView.backgroundColor = [UIColor colorWithRed:231.f/255 green:231.f/255 blue:231.f/255 alpha:1];
    
    UIView* vtop = [[UIView alloc]init];
    vtop.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:vtop];
    _topView = vtop;
    
    [vtop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.height.mas_equalTo(44.f);
    }];
    
    UILabel *view1 = [UILabel new];
    view1.font = [UIFont systemFontOfSize:15];
    _titleView = view1;
    
    [vtop addSubview:_titleView];
    
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.center.equalTo(vtop);
    }];
    
    UILabel *view2 = [UILabel new];
    view2.font = [UIFont systemFontOfSize:14];
    view2.textColor = [UIColor lightGrayColor];
    view2.numberOfLines = 0;
    _detailView = view2;
    
    [self.contentView addSubview:_detailView];
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(vtop.mas_bottom).offset(0);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(QuestionModel *)model
{
    _model = model;
    
    _titleView.text = model.q_title;
    
    _detailView.text = model.q_details;
    
    [_detailView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
