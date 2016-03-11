//
//  EggsHomeViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 12/17/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "EggsHomeViewController.h"
#import "CommonDefine.h"
#import "MJRefresh.h"
#import "LoginManager.h"
#import "UIWindow+YzdHUD.h"
#import "Masonry.h"
#import "HomeIncomeCell.h"
#import "TodayAttendanceCell.h"
#import "HomeCell.h"
#import "TixianMessageCell.h"

@interface EggsHomeViewController ()

@property (strong, nonatomic) id loginedObserver;
@property (strong, nonatomic) id qiandaoStateObserver;
@property (weak, nonatomic) IBOutlet UIImageView *naviBarImageView;

@end

NSString* const NSUserDidLoginedNotification       = @"NSUserDidLoginedNotification" ;
NSString* const NSUserSigninStateNotification      = @"NSUserSigninStateNotification";
NSString* const NSUserSigninNotification           = @"NSUserSigninNotification" ;      //签到
NSString* const NSUserGetMyMoneyNotification       = @"NSUserGetMyMoneyNotification";   //剩余金额
NSString* const NSUserSignUpNotification           = @"NSUserSignUpNotification";
NSString* const NSUserSignUpFailedNotification     = @"NSUserSignUpFailedNotification";
NSString* const NSUserLoginFailedNotification      = @"NSUserLoginFailedNotification";
NSString* const NSUserGetTaskSucceedNotification   = @"NSUserGetTaskSucceedNotification";  //接任务成功
NSString* const NSUserDoTaskFailedNotification     = @"NSUserDoTaskFailedNotification";  //审核任务失败
NSString* const NSUserGetAuthCodeNotification      = @"NSUserGetAuthCodeNotification" ; //获取验证码

@implementation EggsHomeViewController
{
    NSMutableArray* _models;
    NSMutableArray* _messages;
}

- (void)viewWillAppear:(BOOL)animated
{
    DLog(@"viewWillAppear %@", @"123");
    //注册一个监听者，监听数据获取完毕
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.loginedObserver = [center addObserverForName:NSUserDidLoginedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    DLog(@"The user's did logined");
                                                    
                                                    [self.tableView.header endRefreshing];
                                                    
                                                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                    
                                                }];
    
    self.qiandaoStateObserver = [center addObserverForName:NSUserSigninStateNotification object:nil
                                                     queue:mainQueue usingBlock:^(NSNotification *note) {
                                                         
                                                         [self.tableView reloadData];
                                                         
                                                     }];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.loginedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.qiandaoStateObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:235.f/255 green:235.f/255 blue:235.f/255 alpha:1];
    
    [self initializationTableView];
    
    [self createTableHeaderView];
    
    [self createModels];
    
    [self createMessages];
    
    if (!NO_NETWORK) {
        [self setupRefresh];
    }
}

- (void)initializationTableView
{
    self.tableView = [[UITableView alloc]init];
    
    _tableView.dataSource = self;
    _tableView.delegate =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.naviBarImageView.mas_bottom);
        make.bottom.equalTo(self.view).with.offset(-49);
    }];
    
    _tableView.backgroundColor = [UIColor clearColor];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setTableFooterView:v];
}

- (void)createMessages
{
    _messages = [[NSMutableArray alloc]init];
    //读取plist
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TiXianMessage" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSLog(@"data = %@", data);//直接打印数据。
    
    NSArray* messages = data[@"messages"];
    
    for (int i=0; i<messages.count; ++i) {
        TiXianMessage* model = [[TiXianMessage alloc]init];
        model.iconName = messages[i][@"icon"];
        model.name = messages[i][@"name"];
        model.detail = messages[i][@"detail"];
        model.time = messages[i][@"time"];
        [_messages addObject:model];
    }
}

- (void)createModels
{
    _models = [[NSMutableArray alloc]init];
    
    for (int i=0; i<4; ++i) {
        HomeModel* model = [[HomeModel alloc]init];
        
        if (0 == i) {
            model.iconName = @"goldicon";
            model.name = @"赚钱";
            model.detail = @"试玩应用赚现金";
            model.extend = @"绑定手机号后,账号更安全!";
            [_models addObject:model];
        }else if (1 == i)
        {
            model.iconName = @"shoutu";
            model.name = @"收徒";
            model.detail = @"广结门徒开财路";
            model.extend = @"";
            [_models addObject:model];
        }else if (2 == i)
        {
            model.iconName = @"tixian";
            model.name = @"提现";
            model.detail = @"提现红包收话费";
            model.extend = @"";
            [_models addObject:model];
        }else
        {
            model.iconName = @"tixian";
            model.name = @"新手任务";
            model.detail = @"完成新手任务领红包";
            model.extend = @"";
            [_models addObject:model];
        }
    }
}

- (void)createTableHeaderView
{
    UIView* v = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 95 * SCREEN_WIDTH/320.f)];
    
    UIImageView* imgV = [[UIImageView alloc]init];
    imgV.image = [UIImage imageNamed:@"home_ad"];
    imgV.userInteractionEnabled = YES;
    [v addSubview:imgV];
    
    //给广告图片添加点击手势
    if (imgV.gestureRecognizers.count == 0) {
        UITapGestureRecognizer * gestureAd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAd)];
        [imgV addGestureRecognizer:gestureAd];
    }
    
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(v);
    }];
    
    self.tableView.tableHeaderView = v;
}

- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行登录操作
        
        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        
        LoginManager* manager = [LoginManager getInstance];
        
        [manager login];
        
        [manager requestSigninState];  //请求签到状态
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 5;
    }else
    {
        return 0;
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (0 == indexPath.section) {
//        return 80.f;
//    }else if (2 == indexPath.section)
//    {
//        return 62.f;
//    }
//    else
//    {
//        return 44.f;
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (2 == indexPath.section) {
        if (0 == indexPath.row) {
            [self.tabBarController setSelectedIndex:1];
        }else if (3 == indexPath.row)
        {
            [self.tabBarController setSelectedIndex:2];
        }
    }
    
    DLog(@"section.row = %ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0 == section) {
        return 1;
    }else if(1 == section)
    {
        return 1;
    }else if(2 == section)
    {
        return 4;
    }else
    {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* incomeCell = @"incomeCell";
    static NSString* attendanceCell = @"attendanceCell";
    static NSString* cellID1 = @"cellID1";
    static NSString* tixiancell = @"tixiancell";
    
    if (0 == indexPath.section) {
        HomeIncomeCell * cell = [tableView dequeueReusableCellWithIdentifier:incomeCell];
        
        if (cell == nil) {
            cell = [[HomeIncomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:incomeCell];
        }
        
        return cell;
        
    }else if (1 == indexPath.section)
    {
        TodayAttendanceCell* cell = [tableView dequeueReusableCellWithIdentifier:attendanceCell];
        
        if (cell == nil) {
            cell = [[TodayAttendanceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:attendanceCell];
        }
        
        cell.qiandaoAction = ^(){
            [[LoginManager getInstance]signinQianDao];
        };
        
        [cell setStatus];
        
        return cell;
    }else if(2 == indexPath.section)
    {
        HomeCell* cell = [tableView dequeueReusableCellWithIdentifier:cellID1];
        
        if (cell == nil) {
            cell = [[HomeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID1];
        }
        
        cell.model = [_models objectAtIndex:indexPath.row];
        
//        cell.textLabel.text = @"Just Tesst tableViewCell!!!";
        
        return cell;
    }else
    {
        TixianMessageCell* cell = [tableView dequeueReusableCellWithIdentifier:tixiancell];
        
        if (cell == nil) {
            cell = [[TixianMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tixiancell];
        }
        
        cell.model = [_messages objectAtIndex:indexPath.row];
        
        return cell;
    }
    
}

- (void)tapAd
{
    DLog(@"taped ad!!!");
}

- (IBAction)goTask:(id)sender {
    //跳转到任务界面
    [self.tabBarController setSelectedIndex:2];
}
@end
