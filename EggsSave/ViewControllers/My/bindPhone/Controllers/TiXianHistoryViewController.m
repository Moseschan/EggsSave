//
//  TiXianHistoryViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "TiXianHistoryViewController.h"
#import "CommonDefine.h"
#import "Masonry.h"
#import "TiXianListCell.h"
#import "MJRefresh.h"
#import "UIWindow+YzdHUD.h"
#import "LoginManager.h"

@interface TiXianHistoryViewController ()

@property(strong, nonatomic)id tixianRecordObserver;
@property(strong, nonatomic)NSMutableArray* records;

@end

@implementation TiXianHistoryViewController

- (NSMutableArray*)records
{
    if (!_records){
        _records = [NSMutableArray array];
    }
    return _records;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    
    self.tixianRecordObserver = [center addObserverForName:NSUserTiXianRecordNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        
        NSDictionary* dict = note.userInfo;
        
        NSArray* arr = dict[@"getMoneyDetailList"];
        
        if (self.records.count > 0) {
            [_records removeAllObjects];
        }
        
        for (NSInteger i = 0; i < arr.count; ++i) {
            NSDictionary* dic1 = arr[i];
            
            TiXianListCellModel* model = [[TiXianListCellModel alloc]init];
            model.tiAccount = dic1[@"zhiFuBaoZhangHao"];
            model.tiPrice = [NSString stringWithFormat:@"%@元",dic1[@"money"]];
            
            NSDate* confromTimeSp = [NSDate dateWithTimeIntervalSince1970:[dic1[@"createDate"]longValue] / 1000];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MM-dd HH:mm:ss"];
            NSString* selectedStr = [formatter stringFromDate:confromTimeSp];
            
            model.tiTime = selectedStr;
            int cheng = [dic1[@"isZhuanZhang"] intValue];
            if (cheng == 0) {
                model.tiState = @"未转账";
            }else
            {
                model.tiState = @"已转账";
            }
            
            [self.records addObject:model];
        }
        
        [self.tableView reloadData];
        
        [self.tableView.header endRefreshing];
        
        [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
    }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.tixianRecordObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现记录";
    
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
        
        [manager requestTixianRecord];
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
    [vLine1 setFrame:CGRectMake(80.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* vLine2 = [[UIView alloc]init];
    [view addSubview:vLine2];
    vLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine2 setFrame:CGRectMake(160.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* vLine3 = [[UIView alloc]init];
    [view addSubview:vLine3];
    vLine3.backgroundColor = TABLECELL_LINE_COLOR;
    [vLine3 setFrame:CGRectMake(240.f/320.0 * view.frame.size.width, 0, 1, view.frame.size.height)];
    
    UIView* hLine2 = [[UIView alloc]init];
    [view addSubview:hLine2];
    hLine2.backgroundColor = TABLECELL_LINE_COLOR;
    [hLine2 setFrame:CGRectMake(0, view.frame.size.height - 1, view.frame.size.width, 1)];
    
    UILabel* l1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
    l1.text = @"提现金额";
    l1.textAlignment = NSTextAlignmentCenter;
    l1.textColor = [UIColor blackColor];
    [view addSubview:l1];
    [l1 setCenter:CGPointMake(40.0/320 * SCREEN_WIDTH, view.center.y)];
    
    UILabel* l2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
    l2.text = @"提现时间";
    l2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:l2];
    [l2 setCenter:CGPointMake(120.0/320 * SCREEN_WIDTH, view.center.y)];
    
    UILabel* l3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
    l3.text = @"提现账号";
    l3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:l3];
    [l3 setCenter:CGPointMake(200.0/320 * SCREEN_WIDTH, view.center.y)];
    
    UILabel* l4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 18)];
    l4.text = @"提现状态";
    l4.textAlignment = NSTextAlignmentCenter;
    [view addSubview:l4];
    [l4 setCenter:CGPointMake(280.0/320 * SCREEN_WIDTH, view.center.y)];
    
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
    return self.records.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reusedCellId = @"Cell";
    
    TiXianListCell* cell = [tableView dequeueReusableCellWithIdentifier:reusedCellId];
    
    if (cell == nil) {
        cell = [[TiXianListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.model = self.records[indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
