//
//  GroupCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/22/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "GroupCell.h"
#import "Masonry.h"

@implementation GroupCell
{
    UILabel* _detailView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
    }
    
    return self;
}

static UIImage *_image = nil;
- (UIView *)expandableView
{
    if (!_image) {
        _image = [UIImage imageNamed:@"expandableImage.png"];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(0.0, 0.0, _image.size.width, _image.size.height);
    button.frame = frame;
    
    [button setBackgroundImage:_image forState:UIControlStateNormal];
    
    return button;
}

- (void)setup
{
    UILabel *view2 = [UILabel new];
    view2.font = [UIFont systemFontOfSize:14];
    view2.textColor = [UIColor lightGrayColor];
    view2.numberOfLines = 0;
    _detailView = view2;
    
    [self.contentView addSubview:_detailView];
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setInfoWithQuestionGroup:(QuestionGroup *)object
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    _detailView.font = [UIFont systemFontOfSize:15];
    [self setAccessoryView:[self expandableView]];
    
    _detailView.text = object.groupName;
}

- (void)setInfoWithAnswer:(Answer *)object
{
    self.contentView.backgroundColor = [UIColor colorWithRed:231.f/255 green:231.f/255 blue:231.f/255 alpha:1];
    _detailView.font = [UIFont systemFontOfSize:14];
    [self setAccessoryView:nil];
    
    _detailView.text = object.details;
    
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
