//
//  ShareTaskView.m
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "ShareTaskView.h"

@implementation ShareTaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor grayColor];
        
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(10, 200, 300, 100)];
        label.text = @"等待数据中";
        [self addSubview:label];
        [label setAdjustsFontSizeToFitWidth:YES];
        
    }
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
