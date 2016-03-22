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

@interface TiXianHistoryViewController ()

@end

@implementation TiXianHistoryViewController

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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* reusedCellId = @"Cell";
    
    TiXianListCell* cell = [tableView dequeueReusableCellWithIdentifier:reusedCellId];
    
    if (cell == nil) {
        cell = [[TiXianListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusedCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
