//
//  GroupCell.h
//  EggsSave
//
//  Created by 郭洪军 on 3/22/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionGroup.h"
#import "Answer.h"

@interface GroupCell : UITableViewCell

- (void)setInfoWithQuestionGroup:(QuestionGroup *)object;

- (void)setInfoWithAnswer:(Answer *)object;


@end
