//
//  FTDHeadCell.m
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "FTDHeadCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface FTDHeadCell()

@property (weak, nonatomic) IBOutlet UILabel *bodySizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *appFastExplanLabel;
@property (weak, nonatomic) IBOutlet UILabel *appBonusLabel;

@end

@implementation FTDHeadCell

- (void)awakeFromNib {
    // Initialization code
   
}

/**
 *  用户可以获取多少现金奖励
 **/
- (void)setUpAwards
{
    NSUInteger bLength = self.appBonusLabel.text.length;
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.appBonusLabel.text];
    
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, 1)];
    
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:26] range:NSMakeRange(1, bLength-2)];
    
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(bLength-1, 1)];
    
    self.appBonusLabel.attributedText = string;
    
}

- (void)setModel:(FTDHeadModel *)model
{
    _model = model;
    
    _bodySizeLabel.text = model.bodySize;
    _appNameLabel.text = model.name;
    [_appIconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImageName]];
    _appFastExplanLabel.text = model.fastExplain;
    _appBonusLabel.text = [NSString stringWithFormat:@"+ %@ 元",model.price];
    
    [self setUpAwards];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    ;
    
    
    // Configure the view for the selected state
}

@end
