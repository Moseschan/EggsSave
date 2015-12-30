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
#import "UIWindow+YzdHUD.h"

@interface FastTaskView()

@property(strong, nonatomic)NSArray* fastTasks;

@end

@implementation FastTaskView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.mTableView = [[UITableView alloc]initWithFrame:frame];
        
        _mTableView.dataSource = self;
        _mTableView.delegate =self;
        
        //手动添加约束
        _mTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.mTableView];
        
        [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        
        _mTableView.backgroundColor = [UIColor clearColor];
        
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_mTableView setTableFooterView:v];
        
        //数据
        self.fastTasks = [[TasksManager getInstance]getTasks] ;
        [self setupRefresh];
    }
    
    return self;
}

- (void)setupRefresh
{
    // 下拉刷新
    self.mTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行登录操作
        [self.window showHUDWithText:@"刷新中" Type:ShowLoading Enabled:YES];
        
        LoginManager* manager = [LoginManager getInstance];
        [manager login];
    }];
    
}

- (void)refreshData
{
    [self.mTableView reloadData];
    
    [self.mTableView.header endRefreshing];
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
    
    if (self.ftdCellSelected) {
        self.ftdCellSelected(indexPath.row);
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
    cell.detailLabel.text = task.pDetailTaskExplain;
    float bonus = task.pBonus;
    cell.priceLabel.text = [NSString stringWithFormat:@"+%.2f元",bonus/100];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:task.pIconUrl]];
    
    return cell;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
