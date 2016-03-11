//
//  EggsHomeViewController.h
//  EggsSave
//
//  Created by 郭洪军 on 12/17/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EggsHomeViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic)UITableView* tableView;

- (IBAction)goTask:(id)sender;

@end
