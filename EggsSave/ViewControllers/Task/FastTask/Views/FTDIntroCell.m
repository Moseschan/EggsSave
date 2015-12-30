//
//  FTDIntroCell.m
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "FTDIntroCell.h"

@implementation FTDIntroCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setKeyWord:(NSString *)keyword
{
    self.taskKeyWord.text = keyword;
}

- (IBAction)startTask:(id)sender {
    
    if (self.doTaskDidClicked) {
        self.doTaskDidClicked();
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSString *str = [NSString stringWithFormat:
                     @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@#software",
                     [pasteboard.string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    NSLog(@"%@",pasteboard.string);
}
@end
