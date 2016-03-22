//
//  SKSSubTableViewCell.h
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^QuestionCellSelected)(void);

@interface QuestionModel : NSObject

@property(nonatomic, copy)NSString* q_title;
@property(nonatomic, copy)NSString* q_details;

@end

@interface SKSSubTableViewCell : UITableViewCell

@property(strong, nonatomic)QuestionModel* model;
@property(nonatomic, copy)QuestionCellSelected block;

@end
