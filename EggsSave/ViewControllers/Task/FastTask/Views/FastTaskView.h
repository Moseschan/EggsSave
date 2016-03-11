//
//  FastTaskView.h
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Block delegates
 */
typedef void(^FTDetailCellSelected)(NSInteger index);

@interface FastTaskView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(retain, nonatomic)UITableView* tableView;
@property(nonatomic, copy)FTDetailCellSelected ftdCellSelected;

/*
 *从新加载，刷新数据
 */
- (void)refreshData;

@end
