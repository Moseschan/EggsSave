//
//  TaskHistoryViewController.h
//  EggsSave
//
//  Created by 郭洪军 on 3/17/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskHistoryViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic)UITableView* tableView;

@end
