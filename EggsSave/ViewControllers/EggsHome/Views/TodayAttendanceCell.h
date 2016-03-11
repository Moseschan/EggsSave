//
//  TodayAttendanceCell.h
//  EggsSave
//
//  Created by 郭洪军 on 3/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  block delegates
 */

typedef void (^QianDaoAction)(void);

@interface TodayAttendanceCell : UITableViewCell

@property(copy, nonatomic)QianDaoAction qiandaoAction;

- (void)setStatus;

@end
