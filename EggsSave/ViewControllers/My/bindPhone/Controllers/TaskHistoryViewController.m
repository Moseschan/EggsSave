//
//  TaskHistoryViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 3/17/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "TaskHistoryViewController.h"
#import "CommonDefine.h"
#import "Masonry.h"
#import "TaskListCell.h"

@interface TaskHistoryViewController ()

@end

@implementation TaskHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务记录";
    
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    UIView* tableHeader = [self createTableHeader];
    self.tableView.tableHeaderView = tableHeader;
    
}

- (UIView*)createTableHeader
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47.f)];
    view.backgroundColor = TABLEHEADER_COLOR;
    
    UIView* hLine1 = [[UIView alloc]init];
    [view addSubview:hLine1];
    hLine1.backgroundColor = TABLECELL_LINE_COLOR;
    [hLine1 setFrame:CGRectMake(0, 0, view.frame.size.width, 1)];
    
    UIView* vLine1 = [[UIView alloc]init];
    [view addSubview:vLine1];
    vLine1.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine1 setFrame:CGRectMake(148.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
   
    UIView* vLine2 = [[UIView alloc]init];
    [view addSubview:vLine2];
    vLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine2 setFrame:CGRectMake(225.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* hLine2 = [[UIView alloc]init];
    [view addSubview:hLine2];
    hLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [hLine2 setFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
    
    UILabel* l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 18)];
    l1.text = @"任务类型";
    l1.textAlignment = NSTextAlignmentCenter;
    l1.textColor = [UIColor blackColor];
    [view addSubview:l1];
    [l1 setCenter:CGPointMake(74.0/320 * SCREEN_WIDTH, view.center.y)];
    
    UILabel* l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 18)];
    l2.text = @"完成时间";
    l2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:l2];
    [l2 setCenter:CGPointMake(186.0/320 * SCREEN_WIDTH, view.center.y)];
    
    UILabel* l3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 18)];
    l3.text = @"收入";
    l3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:l3];
    [l3 setCenter:CGPointMake(274.0/320 * SCREEN_WIDTH, view.center.y)];
   
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reusedCellId = @"Cell";
    
    TaskListCell* cell = [tableView dequeueReusableCellWithIdentifier:reusedCellId];
    
    if (cell == nil) {
        cell = [[TaskListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
