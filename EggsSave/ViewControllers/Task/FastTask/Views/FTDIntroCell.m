//
//  FTDIntroCell.m
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "FTDIntroCell.h"

@interface FTDIntroCell()

@property (weak, nonatomic) IBOutlet UIButton *startTaskButton;
@property (weak, nonatomic) IBOutlet UIImageView *taskisgetImageView;



@end

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
    
    //先判断是否已经拷贝了关键字
    
    NSString* pasteStr = [UIPasteboard generalPasteboard].string;
    
    if (!pasteStr) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请先拷贝关键字" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        //先进行接任务请求
        if (self.doTaskDidClicked) {
            self.doTaskDidClicked();
        }
    }
}

- (IBAction)commitVerify:(id)sender {
    if (self.submitTaskClicked) {
        self.submitTaskClicked();
    }
}

- (void)setGetTaskSucceed
{
    _startTaskButton.hidden = YES;
    _taskisgetImageView.hidden = NO;
    _taskisgetLabel.hidden = NO;
}

- (void)doTaskFailed
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"傻逼" message:@"请先去完成任务，好吧！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
