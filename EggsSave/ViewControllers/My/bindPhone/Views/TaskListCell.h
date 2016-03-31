//
//  TaskListCell.h
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskListCellModel : NSObject

@property (copy, nonatomic)NSString* taskType;
@property (copy, nonatomic)NSString* finishTime;
@property (copy, nonatomic)NSString* income;

@end

@interface TaskListCell : UITableViewCell

@property(strong, nonatomic)TaskListCellModel* model;

@end
