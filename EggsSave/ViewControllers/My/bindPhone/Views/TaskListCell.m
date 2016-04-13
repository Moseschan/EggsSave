//
//  TaskListCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "TaskListCell.h"
#import "CommonDefine.h"

@implementation TaskListCellModel


@end

@implementation TaskListCell
{
    UILabel* _taskTypeLabel;
    UILabel* _finishTimeLabel;
    UILabel* _incomeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setModel:(TaskListCellModel *)model
{
    _model = model;
    
    _taskTypeLabel.text = model.taskName;
    _finishTimeLabel.text = model.finishTime;
    _incomeLabel.text = model.income;
}

- (void)setup
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 29.f)];
    
    UIView* vLine1 = [[UIView alloc]init];
    [view addSubview:vLine1];
    vLine1.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine1 setFrame:CGRectMake(148.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* vLine2 = [[UIView alloc]init];
    [view addSubview:vLine2];
    vLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine2 setFrame:CGRectMake(225.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* hLine2 = [[UIView alloc]init];
    [view addSubview:hLine2];
    hLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [hLine2 setFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
    
    UILabel* l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 145/320.f*SCREEN_WIDTH, 18)];
    l1.text = @"每日签到奖励";
    l1.adjustsFontSizeToFitWidth = YES;
//    l1.font = [UIFont systemFontOfSize:15];
    l1.textAlignment = NSTextAlignmentCenter;
    l1.textColor = [UIColor blackColor];
    l1.font = [UIFont systemFontOfSize:15];
    l1.textColor = [UIColor lightGrayColor];
    [view addSubview:l1];
    [l1 setCenter:CGPointMake(74.0/320 * SCREEN_WIDTH, view.center.y)];
    _taskTypeLabel = l1;
    
    UILabel* l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75/320.f*SCREEN_WIDTH, 18)];
    l2.text = @"03-04 11:08";
    l2.adjustsFontSizeToFitWidth = YES;
    l2.textAlignment = NSTextAlignmentCenter;
    l2.font = [UIFont systemFontOfSize:15];
    l2.textColor = [UIColor lightGrayColor];
    [view addSubview:l2];
    [l2 setCenter:CGPointMake(186.0/320 * SCREEN_WIDTH, view.center.y)];
    _finishTimeLabel = l2;
    
    UILabel* l3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 95/320.f*SCREEN_WIDTH, 18)];
    l3.text = @"0.04元";
    l2.adjustsFontSizeToFitWidth = YES;
    l3.textAlignment = NSTextAlignmentCenter;
    l3.font = [UIFont systemFontOfSize:15];
    l3.textColor = [UIColor lightGrayColor];
    [view addSubview:l3];
    [l3 setCenter:CGPointMake(274.0/320 * SCREEN_WIDTH, view.center.y)];
    _incomeLabel = l3;
    
    [self.contentView addSubview:view];
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}



@end
