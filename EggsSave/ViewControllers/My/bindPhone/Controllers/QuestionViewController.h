//
//  QuestionViewController.h
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;

@end
