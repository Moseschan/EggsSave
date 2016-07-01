//
//  FTDetailViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 12/28/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "FTDetailViewController.h"
#import "FastTaskCell.h"
#import "FTDHeadCell.h"
#import "Task.h"
#import "FTDIntroCell.h"
#import "LoginManager.h"
#import "CommonDefine.h"
#import "FTDetailCell.h"
#import "Masonry.h"
#import "TimeHeart.h"
#import "ProcessManager.h"
#import "TasksManager.h"
#import "User.h"

#define PROCESS_REFRESH_TIME 15

@interface FTDetailViewController ()
{
    FTDHeadModel*   _model;
    FTDIntroModel*  _introModel;
    
    NSTimer*        _timeLimitTimer;
    NSTimer*        _processTimer;
}

@property (strong, nonatomic) Task* mTask;
@property (strong, nonatomic) id getTaskSucceedObserver;
@property (strong, nonatomic) id doTaskSuccessFailedObserver;

@property (strong, nonatomic)FTDIntroCell* ftdintroCell;

@end

@implementation FTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务详情";
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //这个有条件限制，只针对已经抢到的任务。
    if ([TimeHeart getInstance].isRunning) {
        
        if (self.mTask.pState == 0) {  //任务已经抢到了
            if (_ftdintroCell) {
                [_ftdintroCell setGetTaskSucceed];
                
                [self getTaskRunTime];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.getTaskSucceedObserver = [center addObserverForName:NSUserGetTaskSucceedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    NSDictionary* dict = note.userInfo;
                                                    NSDictionary* responseDict = dict[@"response"];
                                                    int result = [responseDict[@"result"] intValue];
                                                    NSString* message = responseDict[@"message"];
                                                    
                                                    if (result == 0) {
                                                        //将此任务标记为已抢到，未完成任务
                                                        self.mTask.pState = 0;
                                                        
                                                        //改变按钮状态，（此时为显示任务已经领取，不能点击状态）
                                                        [_ftdintroCell setGetTaskSucceed];
                                                        
                                                        //将此任务app加入到白名单
                                                        [[ProcessManager getInstance] writeToWhiteList:self.mTask.pBundleIdentify];
                                                        
                                                        //在这里开一定时器进行计时(判定在时间限制内是否完成了任务)
                                                        _timeLimitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(getTaskRunTime) userInfo:nil repeats:YES];
                                                        
                                                        //标记有任务正在进行
                                                        [TimeHeart getInstance].isRunning = YES;
                                                        
                                                        //监测做任务的情况
                                                        _processTimer = [NSTimer scheduledTimerWithTimeInterval:PROCESS_REFRESH_TIME target:self selector:@selector(checkRunningProcess) userInfo:nil repeats:YES];
                                                        [_processTimer fire];
                                                        
                                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.mTask.pAppStoreURL]];
                                                        
                                                    }else
                                                    {
                                                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"请注意" message:[NSString stringWithFormat:@"接收任务失败，失败原因 : %@", message] delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                                                        
                                                        [alert show];
                                                    }
                                                   
                                                }];
    
    self.doTaskSuccessFailedObserver = [center addObserverForName:NSUserDoTaskCompletedNotification object:nil
                                                       queue:mainQueue usingBlock:^(NSNotification *note) {
                                                           
                                                           NSDictionary* dict = note.userInfo;
                                                           
                                                           int result = [dict[@"result"] intValue]; //0, 成功。1，失败
                                                           
                                                           if (result == 0) {
                                                               //提交完成任务成功
                                                               //服务器返回成功后，做下面操作
                                                               int todayPrice = [dict[@"todayPrice"] intValue];  //今日收入 (单位分)
                                                               int totalPrice = [dict[@"totalPrice"] intValue];  //总金额   (单位分)
                                                               
                                                               User* user = [User getInstance];
                                                               user.todayPrice = todayPrice;
                                                               user.money = totalPrice;
                                                               
                                                               [[NSUserDefaults standardUserDefaults] setObject:nil forKey:FINISHED_TASK_ID_KEY];
                                                               
                                                               UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"您接收的任务已经完成，您将会获得到相应的奖励" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                                                               alert.tag = 1001;
                                                               [alert show];
                                                               
                                                           }else
                                                           {
                                                               //提交完成任务失败
                                                               [_ftdintroCell doTaskFailed];
//                                                               NSString* message = dict[@"message"];
                                                           }
                                                           
                                                       }];
    
    if (_ftdintroCell) {
        if (self.mTask.pState == 1) {
            _ftdintroCell.taskisgetLabel.text = @"任务已完成";    //此时可以提交了
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1001) {
        [_timeLimitTimer invalidate];
        [TimeHeart getInstance].time = 0;
        self.mTask.pState = 1;
        
        _ftdintroCell.taskisgetLabel.text = @"任务已完成";
    }
}

- (void)checkRunningProcess
{
    //扫描手机内正在运行的进程
    [[ProcessManager getInstance] loadIOKit];
    
    //判断任务进程是否开启，开启开始计时，否则不计时
    BOOL iscunzai = [[ProcessManager getInstance]processIsRunning:self.mTask.pProcessNum];
    
    if (iscunzai) {
        DLog(@"应用正在运行");
        [TimeHeart getInstance].isDownloaded = YES;
    }else
    {
        DLog(@"应用未运行");
        [TimeHeart getInstance].isDownloaded = NO;
    }
    
    if ([TimeHeart getInstance].isDownloaded) {
        [TimeHeart getInstance].swTime += PROCESS_REFRESH_TIME ;   //累计试玩时间
    }else
    {
        [TimeHeart getInstance].swTime = 0;    //中途，如果退出了任务进程，则计时归零，重新来
    }
    
    //判断试玩时间是否达到了任务要求的时间
    if ([TimeHeart getInstance].swTime >= self.mTask.pShiwanTime * 60) {
        //任务完成 无需再进行监控
//        [_timeLimitTimer invalidate];
        [_processTimer invalidate];
        
        [TimeHeart getInstance].isRunning = NO;
//        [TimeHeart getInstance].time = 0;
        //此时，需要记录下已经完成的任务
        [[NSUserDefaults standardUserDefaults] setObject:self.mTask.pId forKey:FINISHED_TASK_ID_KEY];
        
//        _ftdintroCell.taskisgetLabel.text = @"任务已完成";
        //将此任务标记为已抢到，完成任务
//        self.mTask.pState = 1;
    }
}

- (void)getTaskRunTime
{
    [TimeHeart getInstance].time += 1;  //计时，单位1秒
    
    if (_ftdintroCell) {
        
        if (self.mTask) {
            
            NSUInteger needTime = self.mTask.pTaskLimit;
            
            NSUInteger needMinutes = needTime - ([TimeHeart getInstance].time) / 60 ;
            
            [_ftdintroCell updateTimeWithLeftTime:needMinutes];
            
            if (needMinutes == 0) {
                
                //判断任务完成与否
                [_timeLimitTimer invalidate];
                [_processTimer invalidate];
                
                [TimeHeart getInstance].isRunning = NO;
                [TimeHeart getInstance].time = 0;
            }
            
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.getTaskSucceedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.doTaskSuccessFailedObserver];
}

- (void)setTask:(Task*)task
{
    self.mTask = task;
    
    _model = [FTDHeadModel new];
    _model.name = _mTask.pTitle;
    _model.bodySize = _mTask.pPackagesize;
    _model.iconImageName = _mTask.pIconUrl;
    _model.price = [NSString stringWithFormat:@"%.2f", _mTask.pBonus/100];
    _model.fastExplain = _mTask.pFastTaskExplain;
    
    FTDIntroModel* mo2 = [FTDIntroModel new];
    
    NSArray *tempArray = [NSArray arrayWithArray:_mTask.returnDetailArray];
    mo2.details = tempArray;
    
    _introModel = mo2;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UILabel *label = [[UILabel alloc] init];
        label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        label.text = @"任务步骤";
        return label;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        FTDHeadCell* cell = nil;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FTDHeadCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.model = _model;
        
        return cell;
       
    } else if (indexPath.section == 1) {
        FTDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FTDetailCell"];
        if (cell == nil) {
            cell = [[FTDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FTDetailCell"];
        }
        
        cell.model = _introModel;
        __weak typeof(self)weakSelf = self;
        cell.reloadCellBlock = ^{
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return cell;
    } else {
        UITableViewCell* cell = nil;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FTDIntroCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        _ftdintroCell = (FTDIntroCell*)cell ;
        [_ftdintroCell setKeyWord:self.mTask.pKeyWord];
        
        if ([TimeHeart getInstance].isRunning) {
            
            //领取了任务但是未完成
            if (self.mTask.pState == 0) {
                [_ftdintroCell setGetTaskSucceed];
                [self getTaskRunTime];
            }
        }else
        {
            long state = self.mTask.pState;
            if (state == 0) {
                //领取了任务，未完成
                [_ftdintroCell setGetTaskSucceed];
            }else if(state == 1)
            {
                DLog(@"任务已经完成");
                [_ftdintroCell setGetTaskSucceed];
                _ftdintroCell.taskisgetLabel.text = @"任务已完成";
            }else if (state == 2)
            {
                DLog(@"未领取任务");
            }
        }
        __weak __typeof(self)weakSelf = self;
        _ftdintroCell.doTaskDidClicked = ^()
        {
            //请求做任务接口
            //先检测是否可接（如果有正在进行的任务，则不可接）
            int appState = [weakSelf isTaskCanAccept:weakSelf.mTask];
            
            if (0 == appState) {
                //没有进程正在运行
                [[LoginManager getInstance] doTaskWithTaskId:weakSelf.mTask.pId];
                
            }else if (1 == appState)
            {
                //进程正在运行
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"别着急" message:@"心急吃不了热豆腐，还是先去完成已抢到的其他任务吧!" delegate:weakSelf cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                
                [alert show];
            }
            
        };
        
        _ftdintroCell.submitTaskClicked = ^(){
            NSString* task_id = [[NSUserDefaults standardUserDefaults]objectForKey:FINISHED_TASK_ID_KEY];
            if (![task_id isEqual:weakSelf.mTask.pId]) {
                
                //如果没有，首先应判断任务是否已经完成了
                if (weakSelf.mTask.pState == 1) {
                    //任务已经完成，并且提交过了
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"请注意" message:@"任务已经完成并且提交过了，请勿重复提交!" delegate:weakSelf cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }else
                {
                    //任务未完成，提示先完成任务
                    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"别着急" message:@"心急吃不了热豆腐，还是先去完成任务吧!" delegate:weakSelf cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                    
                    [alert show];
                }
            }else
            {
                //请求 提交任务已经完成, 之后将已完成id置空
                [[LoginManager getInstance]requestTaskFinishedWithTaskID:weakSelf.mTask.pId];
                
            }
            
        };
        
        return cell;
    }
}

#pragma mark - other methods 
- (int)isTaskCanAccept:(Task*)task
{
    int bRet = 0;
    
    NSArray* tasks = [[TasksManager getInstance]getTasks];
    for (NSUInteger i=0; i<tasks.count; ++i) {
        
        Task* tempTask = tasks[i];
        
        if (![tempTask isEqual:task]) {
            if (tempTask.pState == 0) {
                bRet = 1;
            }
        }
    }
    
    return bRet;  //0，没有进程正在运行  1, 进程正在运行
}

@end
