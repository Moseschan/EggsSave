//
//  FTDIntroCell.h
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoTaskDidClicked)(void);
typedef void(^SubmitTaskClicked)(void);

@interface FTDIntroCell : UITableViewCell

@property(nonatomic, copy)DoTaskDidClicked doTaskDidClicked;
@property(nonatomic, copy)SubmitTaskClicked submitTaskClicked;
@property (weak, nonatomic) IBOutlet UITextView *taskKeyWord;
@property (weak, nonatomic) IBOutlet UILabel *taskisgetLabel;

- (IBAction)startTask:(id)sender;
- (IBAction)commitVerify:(id)sender;

- (void)setKeyWord:(NSString *)keyword;

- (void)setGetTaskSucceed;
- (void)doTaskFailed;

@end
