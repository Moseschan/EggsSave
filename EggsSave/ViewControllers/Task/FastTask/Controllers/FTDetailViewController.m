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

@interface FTDetailViewController ()
{
    FTDHeadModel* _model;
    FTDIntroModel* _introModel;
}

@property (strong, nonatomic)Task* mTask;
@property (strong, nonatomic) id getTaskSucceedObserver;
@property (strong, nonatomic) id doTaskFailedObserver;

@property (strong, nonatomic)FTDIntroCell* ftdintroCell;

@end

@implementation FTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务详情";
    
//    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blueColor], NSForegroundColorAttributeName, nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    //先移除剪贴板的值
    [[UIPasteboard generalPasteboard] setString:@""];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.getTaskSucceedObserver = [center addObserverForName:NSUserGetTaskSucceedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
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
                                                    
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                                                    DLog(@"%@",pasteboard.string);
                                                    //相应的接任务接口变化
                                                    
                                                }];
    
    self.doTaskFailedObserver = [center addObserverForName:NSUserDoTaskFailedNotification object:nil
                                                       queue:mainQueue usingBlock:^(NSNotification *note) {
                                                           
                                                           [_ftdintroCell doTaskFailed];
                                                           
                                                           DLog(@"The user do task failed!");
                                                           
                                                           //相应的接任务接口变化
                                                           
                                                       }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.getTaskSucceedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.doTaskFailedObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTask:(Task*)task
{
    self.mTask = task;
    
    _model = [FTDHeadModel new];
    _model.name = _mTask.pTitle;
    _model.bodySize = @"17.9";
    _model.iconImageName = _mTask.pIconUrl;
    _model.price = [NSString stringWithFormat:@"%.2f", _mTask.pBonus/100];
    _model.fastExplain = _mTask.pFastTaskExplain;
    
    FTDIntroModel* mo2 = [FTDIntroModel new];
    
    NSMutableString *tempStr = [NSMutableString stringWithString:_mTask.pDetailTaskExplain];
    NSString *strUrl = [tempStr stringByReplacingOccurrencesOfString:@"。" withString:@"\n"];
    

    mo2.details = strUrl;
    _introModel = mo2;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 96;
    }else if(indexPath.row == 1)
    {
        return 60;
    }else
    {
        return 200;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return @"任务步骤";
    }else if (2 == section)
    {
        return nil;
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"test";
    
    if (indexPath.section == 0) {
        FTDHeadCell* cell = nil;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FTDHeadCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.model = _model;
        
        return cell;
        
    }else if(1 == indexPath.section)
    {
        
        FTDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[FTDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        
        cell.block = ^() {
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        cell.model = _introModel;
        
        return cell;
        
    }else
    {
        UITableViewCell* cell = nil;
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FTDIntroCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        _ftdintroCell = (FTDIntroCell*)cell ;
        
        [_ftdintroCell setKeyWord:self.mTask.pKeyWord];
        
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
        
        __weak __typeof(self)weakSelf = self;
        
        _ftdintroCell.doTaskDidClicked = ^()
        {
            //请求做任务接口
            [[LoginManager getInstance] doTaskWithTaskId:weakSelf.mTask.pId];
        };
        
        _ftdintroCell.submitTaskClicked = ^(){
            //提交审核任务接口
            [[LoginManager getInstance] submitTaskWithTaskId:weakSelf.mTask.pId];
        };
        
        return cell;
    }

}


@end
