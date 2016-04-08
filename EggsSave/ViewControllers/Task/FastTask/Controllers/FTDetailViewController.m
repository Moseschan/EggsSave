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
    //先移除剪贴板的值
    [[UIPasteboard generalPasteboard] setString:@""];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.getTaskSucceedObserver = [center addObserverForName:NSUserGetTaskSucceedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    //将此任务标记为已抢到，未完成任务
                                                    self.mTask.pState = 0;
                                                    
                                                    NSDictionary* dict = note.userInfo;
                                                    NSDictionary* responseDict = dict[@"response"];
                                                    int result = [responseDict[@"result"] intValue];
                                                    NSString* message = responseDict[@"message"];
                                                    
                                                    if (result == 0) {
                                                        DLog(@"接受任务成功");
                                                        [_ftdintroCell setGetTaskSucceed];
                                                    }else
                                                    {
                                                        DLog(@"接受任务失败，失败原因 : %@", message);
                                                    }
                                                    
                                                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                    NSString *str = [NSString stringWithFormat:
                                                                     @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@#software",
                                                                     [pasteboard.string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
                                                    
                                                    //在这里开一定时器进行计时
                                                    _timeLimitTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(getTaskRunTime) userInfo:nil repeats:YES];
                                                    [TimeHeart getInstance].isRunning = YES;
                                                    
                                                    //监测做任务的情况
                                                    _processTimer = [NSTimer scheduledTimerWithTimeInterval:PROCESS_REFRESH_TIME target:self selector:@selector(checkRunningProcess) userInfo:nil repeats:YES];
                                                    [_processTimer fire];
                                                    
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                                                    DLog(@"%@",pasteboard.string);
                                                    //相应的接任务接口变化
                                                    
                                                }];
    
    self.doTaskSuccessFailedObserver = [center addObserverForName:NSUserDoTaskCompletedNotification object:nil
                                                       queue:mainQueue usingBlock:^(NSNotification *note) {
                                                           
//                                                           NSDictionary* dict = note.userInfo;
                                                           
                                                           [_ftdintroCell doTaskFailed];
                                                           
                                                           DLog(@"The user do task failed!");
                                                           
                                                           //相应的接任务接口变化
                                                           
                                                       }];
}

- (void)checkRunningProcess
{
    [[ProcessManager getInstance] loadIOKit];
    
    BOOL iscunzai = [[ProcessManager getInstance]processIsRunning:self.mTask.pProcessNum];  //discover要换成当前任务应用的进程号.
    
    if (iscunzai) {
        NSLog(@"应用正在运行");
        [TimeHeart getInstance].isDownloading = YES;
    }else
    {
        NSLog(@"应用尚未运行");
        [TimeHeart getInstance].isDownloading = NO;
    }
    
    if ([TimeHeart getInstance].isDownloading) {
        [TimeHeart getInstance].swTime += PROCESS_REFRESH_TIME ;
    }else
    {
        [TimeHeart getInstance].swTime = 0;
    }
    
    if ([TimeHeart getInstance].swTime >= self.mTask.pShiwanTime * 60) {
        //任务完成 向服务器发送任务完成的请求
        [_timeLimitTimer invalidate];
        [_processTimer invalidate];
        
        //请求
        _ftdintroCell.taskisgetLabel.text = @"任务已完成";
//        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"恭喜您" message:@"此任务您已经完成" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
//        
//        [alert show];
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
                [TimeHeart getInstance].lastTime = 0;
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
            
            if (self.mTask.pState == 0) {
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
                //没有进程正在运行，但是已经安装应用了
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"对不起" message:@"您不能做此任务，因为你已经安装过应用" delegate:weakSelf cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                
                [alert show];
                
                //此时我需要通知服务器，下次不能给这个用户返这个任务了
            }else if (1 == appState)
            {
                //进程正在运行
                UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"别着急" message:@"心急吃不了热豆腐，还是先去完成已抢到的其他任务吧!" delegate:weakSelf cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
                
                [alert show];
            }else
            {
                //没有进程正在运行，并且未安装应用
                [[LoginManager getInstance] doTaskWithTaskId:weakSelf.mTask.pId];
            }
            
        };
        
        _ftdintroCell.submitTaskClicked = ^(){
            //提交审核任务接口
            [[LoginManager getInstance] submitTaskWithTaskId:weakSelf.mTask.pId];
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
    
    if (bRet != 1) {

        NSArray* arr = [[ProcessManager getInstance] getAllAppsInstalled];
        bRet = 2 ;
        NSString* bundleId = self.mTask.pUrlScheme;
        for (NSUInteger j = 0; j < arr.count; ++j) {
            if ([bundleId isEqual:arr[j]]) {
                bRet = 0;
            }
        }
    }
    
    return bRet;  //0，没有进程正在运行，但是已经安装应用了  1, 进程正在运行  2, 没有进程正在运行，并且未安装应用
}

@end
