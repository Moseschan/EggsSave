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

@implementation FTDetailCell
{
    UILabel* _detailView;
    UIImageView *_imageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UILabel *detailView = [UILabel new];
    detailView.textColor = [UIColor lightGrayColor];
    detailView.font = [UIFont systemFontOfSize:16];
    detailView.numberOfLines = 0;
    [self.contentView addSubview:_detailView = detailView];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView = imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_detailView.mas_bottom).offset(-15);
        make.left.mas_equalTo(25);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)setModel:(FTDIntroModel *)model {
    _model = model;
    
    NSArray *array = [model.details componentsSeparatedByString:@"img:"];
    _detailView.text = array[0];
    NSURL *url = [NSURL URLWithString:[array[1] substringToIndex:[array[1] length]-1]];
    
    [_imageView sd_setImageWithURL:url placeholderImage:[[UIImage alloc] init] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.block();
    }];
}

@end
