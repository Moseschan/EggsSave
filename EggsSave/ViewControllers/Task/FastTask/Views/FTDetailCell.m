//
//  FTDetailCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/3/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "FTDetailCell.h"
#import "Masonry.h"

@implementation FTDetailCell
{
    UILabel* _detailView;
}

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UILabel *view1 = [UILabel new];
    view1.textColor = [UIColor lightGrayColor];
    view1.font = [UIFont systemFontOfSize:16];
    view1.numberOfLines = 0;
    _detailView = view1;
    
    [self.contentView addSubview:_detailView];
    
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.bottom.mas_equalTo(-10);
    }];
}

- (void)setModel:(FTDIntroModel *)model
{
    _model = model;
    
    _detailView.text = model.details;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
