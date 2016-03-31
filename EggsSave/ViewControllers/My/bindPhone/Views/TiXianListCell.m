//
//  TiXianListCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "TiXianListCell.h"
#import "CommonDefine.h"

@implementation TiXianListCellModel
@end

@implementation TiXianListCell
{
    UILabel*      _accountLabel;
    UILabel*      _priceLabel;
    UILabel*      _timeLabel;
    UILabel*      _stateLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setModel:(TiXianListCellModel *)model
{
    _model = model;
    
    _accountLabel.text = _model.tiAccount;
    _priceLabel.text = _model.tiPrice;
    _timeLabel.text = _model.tiTime;
    _stateLabel.text = _model.tiState;
}

- (void)setup
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 29.f)];
    
    UIView* vLine1 = [[UIView alloc]init];
    [view addSubview:vLine1];
    vLine1.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine1 setFrame:CGRectMake(80.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* vLine2 = [[UIView alloc]init];
    [view addSubview:vLine2];
    vLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine2 setFrame:CGRectMake(160.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* vLine3 = [[UIView alloc]init];
    [view addSubview:vLine3];
    vLine3.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine3 setFrame:CGRectMake(240.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* hLine2 = [[UIView alloc]init];
    [view addSubview:hLine2];
    hLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [hLine2 setFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
    
    
    UILabel* l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80/320.f*SCREEN_WIDTH, 18)];
    l1.text = @"10元";
    l1.textColor = TABLE_TEXT_COLOR;
    l1.adjustsFontSizeToFitWidth = YES;
    l1.textAlignment = NSTextAlignmentCenter;
    l1.font = [UIFont systemFontOfSize:15];
    l1.textColor = [UIColor lightGrayColor];
    [view addSubview:l1];
    [l1 setCenter:CGPointMake(40.0/320 * SCREEN_WIDTH, view.center.y)];
    _priceLabel = l1;
    
    UILabel* l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80/320.f*SCREEN_WIDTH, 18)];
    l2.text = @"03-04 11:08";
    l2.textColor = TABLE_TEXT_COLOR;
    l2.adjustsFontSizeToFitWidth = YES;
    l2.textAlignment = NSTextAlignmentCenter;
    l2.textColor = [UIColor lightGrayColor];
    [view addSubview:l2];
    [l2 setCenter:CGPointMake(120.0/320 * SCREEN_WIDTH, view.center.y)];
    _timeLabel = l2;
    
    UILabel* l3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80/320.f*SCREEN_WIDTH, 18)];
    l3.text = @"zeusghj@163.com";
    l3.textColor = TABLE_TEXT_COLOR;
    l3.adjustsFontSizeToFitWidth = YES;
    l3.textAlignment = NSTextAlignmentCenter;
    l3.textColor = [UIColor lightGrayColor];
    [view addSubview:l3];
    [l3 setCenter:CGPointMake(200.0/320 * SCREEN_WIDTH, view.center.y)];
    _accountLabel = l3;
    
    UILabel* l4= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80/320.f*SCREEN_WIDTH, 18)];
    l4.text = @"成功";
    l4.textColor = TABLE_TEXT_COLOR;
    l4.adjustsFontSizeToFitWidth = YES;
    l4.textAlignment = NSTextAlignmentCenter;
    l4.textColor = [UIColor lightGrayColor];
    l4.font = [UIFont systemFontOfSize:15];
    [view addSubview:l4];
    [l4 setCenter:CGPointMake(280.0/320 * SCREEN_WIDTH, view.center.y)];
    _stateLabel = l4;
    
    [self.contentView addSubview:view];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
