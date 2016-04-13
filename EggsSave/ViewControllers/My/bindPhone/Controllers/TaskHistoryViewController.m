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
#import "MJRefresh.h"
#import "UIWindow+YzdHUD.h"
#import "LoginManager.h"

@interface TaskHistoryViewController ()

@property(strong, nonatomic)id taskRecordObserver;
@property(strong, nonatomic)NSMutableArray* taskRecords;

@end

@implementation TaskHistoryViewController

- (NSMutableArray*)taskRecords
{
    if (!_taskRecords) {
        _taskRecords = [NSMutableArray array];
    }
    return _taskRecords;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.taskRecordObserver];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    
    self.taskRecordObserver = [center addObserverForName:NSUserTaskRecordNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
        NSDictionary* dict = note.userInfo;
        
        NSArray* arr = dict[@"userSuccessTaskReturnList"];
        
        if (self.taskRecords.count > 0) {
            [_taskRecords removeAllObjects];
        }
        
        for (NSInteger i = 0; i < arr.count; ++i) {
            NSDictionary* dic1 = arr[i];

            TaskListCellModel* model = [[TaskListCellModel alloc]init];
            model.taskName = dic1[@"taskName"];
            model.income = [NSString stringWithFormat:@"%.2f元",[dic1[@"price"] intValue] / 100.f];

            NSDate* confromTimeSp = [NSDate dateWithTimeIntervalSince1970:[dic1[@"createDate"]longValue] / 1000];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm"];
            NSString* selectedStr = [formatter stringFromDate:confromTimeSp];

            model.finishTime = selectedStr;

            [self.taskRecords addObject:model];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        
        [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
    }];
}

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
    
    if (!NO_NETWORK) {
        [self setupRefresh];
    }
    
}

- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行登录操作
        
        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        
        LoginManager* manager = [LoginManager getInstance];
        
        [manager requestTaskRecord];
    }];
    
    [self.tableView.header beginRefreshing];
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
    l1.text = @"任务名";
    l1.textAlignment = NSTextAlignmentCenter;
    l1.textColor = [UIColor blackColor];
//    l1.font = [UIFont systemFontOfSize:15];
    [view addSubview:l1];
    [l1 setCenter:CGPointMake(74.0/320 * SCREEN_WIDTH, view.center.y)];
    
    UILabel* l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 18)];
    l2.text = @"完成时间";
    l2.textAlignment = NSTextAlignmentCenter;
//    l2.font = [UIFont systemFontOfSize:15];
    [view addSubview:l2];
    [l2 setCenter:CGPointMake(186.0/320 * SCREEN_WIDTH, view.center.y)];
    
    UILabel* l3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 18)];
    l3.text = @"收入";
    l3.textAlignment = NSTextAlignmentCenter;
//    l3.font = [UIFont systemFontOfSize:15];
    [view addSubview:l3];
    [l3 setCenter:CGPointMake(274.0/320 * SCREEN_WIDTH, view.center.y)];
   
    return view;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29.0f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.taskRecords.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reusedCellId = @"Cell";
    
    TaskListCell* cell = [tableView dequeueReusableCellWithIdentifier:reusedCellId];
    
    if (cell == nil) {
        cell = [[TaskListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = self.taskRecords[indexPath.row];
    
    return cell;
}

@end
