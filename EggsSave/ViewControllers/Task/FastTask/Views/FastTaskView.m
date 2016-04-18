//
//  FastTaskView.m
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "FastTaskView.h"
#import "Masonry.h"
#import "FastTaskCell.h"
#import "TasksManager.h"
#import "Task.h"
#import "MJRefresh.h"
#import "LoginManager.h"
#import "CommonDefine.h"
#import "WKProgressHUD.h"

@interface FastTaskView()

@property(strong, nonatomic)NSArray* fastTasks;

@end

@implementation FastTaskView
{
    WKProgressHUD* _hud;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.tableView = [[UITableView alloc]initWithFrame:frame];
        
        _tableView.dataSource = self;
        _tableView.delegate =self;
        
        //手动添加约束
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        
        _tableView.backgroundColor = [UIColor clearColor];
        
        // 设置tableHeader
        UIView* headView = [self setUpTableHeader];
        self.tableView.tableHeaderView = headView;
        
        // 可以隐藏tableviewcell之间的分割线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:v];
        
        //数据
        self.fastTasks = [[TasksManager getInstance]getTasks] ;
        
        if (!NO_NETWORK) {
            [self setupRefresh];
        }
    }
    
    return self;
}

- (UIView *)setUpTableHeader
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 62)];
    
    UILabel* introLabel = [[UILabel alloc]init];
    introLabel.numberOfLines = 0;
    introLabel.text = @"\t选择任意快速任务，下载、安装玩游戏，就能每天轻松赚入零花钱。玩越多赚越多，现在就开始吧！";
    introLabel.textColor = [UIColor grayColor];
    introLabel.font = [UIFont systemFontOfSize:14];
    [v addSubview:introLabel];
    v.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
    
    [introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(v);
        make.left.equalTo(v).with.offset(10);
        make.right.equalTo(v).with.offset(-10);
    }];
    
    return v;
}

- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行登录操作
#warning mark - 此处之后显示没有消失，请注意
        if (!_hud) {
            _hud = [WKProgressHUD showInView:self withText:@"加载中" animated:YES];
        }
        
        LoginManager* manager = [LoginManager getInstance];
        [manager login];
    }];
    
}

- (void)refreshData
{
    //数据
    self.fastTasks = [[TasksManager getInstance]getTasks] ;
    
    [self.tableView reloadData];
    
    [self.tableView.header endRefreshing];
}

#pragma mark - UITableViewDelegate and datasource.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fastTasks count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 62;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    // 三个方法并用，实现自定义分割线效果
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = insets;
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:insets];
    }
    
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //判断留存任务，还是下载试玩任务
    Task* task =  [[TasksManager getInstance] getTasks][indexPath.row];
    
    if (task.pTaskType == 1) {
        //下载任务
        if (self.ftdCellSelected) {
            self.ftdCellSelected(indexPath.row);
        }
    }else
    {
        //留存
        NSURL* url = [NSURL URLWithString:task.pUrlScheme] ;
        
        [[UIApplication sharedApplication]openURL:url];
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"fasttaskcell";
    
    FastTaskCell *cell           = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FastTaskCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Task* task = _fastTasks[indexPath.row] ;
    
    cell.titleLabel.text = task.pTitle;
    cell.detailLabel.text = task.pSubTitle;
    float bonus = task.pBonus;
    cell.priceLabel.text = [NSString stringWithFormat:@"+%.2f元",bonus/100];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:task.pIconUrl]];
    
    return cell;
    
}

@end
