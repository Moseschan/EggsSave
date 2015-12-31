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

@interface FTDetailViewController ()

@property (strong, nonatomic)Task* mTask;
@property (strong, nonatomic) id getTaskSucceedObserver;
@property (strong, nonatomic) id doTaskFailedObserver;

@property (strong, nonatomic)FTDIntroCell* ftdintroCell;

@end

@implementation FTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    //先移除剪贴板的值
    [[UIPasteboard generalPasteboard] setString:@""];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.getTaskSucceedObserver = [center addObserverForName:NSUserGetTaskSucceedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    [_ftdintroCell setGetTaskSucceed];
                                                    
                                                    NSLog(@"The user get task succeed!");
                                                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                                    
                                                    NSString *str = [NSString stringWithFormat:
                                                                     @"https://itunes.apple.com/WebObjects/MZStore.woa/wa/search?mt=8&submit=edit&term=%@#software",
                                                                     [pasteboard.string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
                                                    
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                                                    NSLog(@"%@",pasteboard.string);
                                                    //相应的接任务接口变化
                                                    
                                                }];
    
    self.doTaskFailedObserver = [center addObserverForName:NSUserDoTaskFailedNotification object:nil
                                                       queue:mainQueue usingBlock:^(NSNotification *note) {
                                                           
                                                           [_ftdintroCell doTaskFailed];
                                                           
                                                           NSLog(@"The user do task failed!");
                                                           
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 78;
    }else if (1 == indexPath.section)
    {
        return 288;
    }else
    {
        return 78;
    }
    return 78;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (1 == section) {
        return @"任务说明";
    }else if (2 == section)
    {
        return @"应用详情";
    }
    
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = nil;
    
    if (indexPath.section == 0) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FTDHeadCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }else if(1 == indexPath.section)
    {
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
            NSLog(@"任务已经完成");
            [_ftdintroCell setGetTaskSucceed];
            _ftdintroCell.taskisgetLabel.text = @"任务已完成";
        }else if (state == 2)
        {
            NSLog(@"未领取任务");
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
        
    }else
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"FTDHeadCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
        
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
