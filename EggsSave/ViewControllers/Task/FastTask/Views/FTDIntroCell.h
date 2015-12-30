//
//  FTDIntroCell.h
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoTaskDidClicked)(void);

@interface FTDIntroCell : UITableViewCell

@property(nonatomic, copy)DoTaskDidClicked doTaskDidClicked;
@property (weak, nonatomic) IBOutlet UITextView *taskKeyWord;

- (IBAction)startTask:(id)sender;

- (void)setKeyWord:(NSString *)keyword;

@end
