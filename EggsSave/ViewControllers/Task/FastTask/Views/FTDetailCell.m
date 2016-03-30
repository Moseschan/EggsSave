//
//  FTDetailCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/3/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "FTDetailCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface FTDetailCell ()

@property (nonatomic, weak) UIView *flagView;

@end

@implementation FTDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(FTDIntroModel *)model {
    _model = model;
    
    NSArray *array = model.details;
    NSArray *numArray = @[@"①",@"②",@"③",@"④",@"⑤",@"⑥",@"⑦",@"⑧",@"⑨"];
    NSInteger labelFlag = 0, imageFlag = 0;
    
    for (NSInteger i = 0; i < array.count; ++i) {
        NSString *string = array[i];
        
        if ([string hasPrefix:@"http://"]) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [imageView sd_setImageWithURL:[NSURL URLWithString:string]];
            [self addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.flagView.mas_bottom).offset(5);
                make.centerX.mas_equalTo(0);
                make.height.mas_equalTo(imageFlag?130:205);
                if (i == array.count-1) {
                    make.bottom.mas_equalTo(-10);
                }
            }];
            
            ++imageFlag;
            self.flagView = imageView;
        } else {
            UILabel *detailLabel = [[UILabel alloc] init];
            detailLabel.textColor = [UIColor lightGrayColor];
            detailLabel.font = [UIFont systemFontOfSize:16];
            detailLabel.text = [NSString stringWithFormat:@"%@ %@",numArray[labelFlag], string];
            [self addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (i == 0) {
                    make.top.mas_equalTo(10);
                } else {
                    make.top.mas_equalTo(self.flagView.mas_bottom).offset(5);
                }
                make.left.mas_equalTo(10);
                make.height.mas_equalTo(20);
                if (i == array.count-1) {
                    make.bottom.mas_equalTo(-10);
                }
            }];
            
            ++labelFlag;
            self.flagView = detailLabel;
        }
    }
}

@end
