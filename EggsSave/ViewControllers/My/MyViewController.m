//
//  MyViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 12/31/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewHeader.h"
#import "MyTableViewCell.h"
#import "BindPhoneViewController.h"
#import "PersonalMessageViewController.h"
#import "CommonDefine.h"
#import "changePassword/CHPViewController.h"
#import "TaskHistoryViewController.h"
#import "TiXianHistoryViewController.h"
#import "AboutViewController.h"
#import "QuestionViewController.h"
#import "FeedBackViewController.h"

@interface MyViewController ()
{
    MyTableViewHeader* mHeadView;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:NAVIBARTITLECOLOR};
    
    self.navigationController.navigationBar.tintColor = NAVIBARTINTCOLOR;
    
    __weak __typeof(self)weakSelf = self;
    
    mHeadView = [[MyTableViewHeader alloc]init];
    mHeadView.mthSetMessage = ^(){
        PersonalMessageViewController* pmvc = InstFirstVC(@"PersonalMessageViewController");
        
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        
        temporaryBarButtonItem.title=@"返回";
        
        weakSelf.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        
//        pmvc.hidesBottomBarWhenPushed = YES;
        [weakSelf.navigationController pushViewController:pmvc animated:YES];
    };
    
    __weak __typeof(mHeadView)weakHeadView = mHeadView;
    
    mHeadView.mthShowAvatar = ^(){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
        UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
        weakHeadView.avatarImageView.image = selfPhoto;
        [weakHeadView.avatarImageView.layer setCornerRadius:CGRectGetHeight([weakHeadView.avatarImageView bounds]) / 2];
        weakHeadView.avatarImageView.layer.masksToBounds = YES;
    };
    
    self.tableView.tableHeaderView = mHeadView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [mHeadView showAvatar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 4;
    }else
    {
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"mytableviewcellid";
    
    MyTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //    cell.backgroundColor = [UIColor redColor];
    
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // Configure the cell...
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"手机绑定";
            cell.bindLabel.hidden = NO;
        }else if (indexPath.row == 1)
        {
            cell.titleLabel.text = @"任务记录";
        }else if (indexPath.row == 2)
        {
            cell.titleLabel.text = @"提现记录";
        }else if (indexPath.row == 3)
        {
            cell.titleLabel.text = @"常见问题";
        }
    }else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            cell.titleLabel.text = @"修改密码";
        }else if (indexPath.row == 1)
        {
            cell.titleLabel.text = @"问题反馈";
        }else
        {
            cell.titleLabel.text = @"关于我们";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else
    {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            //绑定手机
            BindPhoneViewController* bpvc = InstFirstVC(@"BindPhoneViewController");
            
            UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
            
            temporaryBarButtonItem.title=@"返回";
            
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
//            bpvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:bpvc animated:YES];
        }else if (1 == indexPath.row)
        {
            //任务记录
            TaskHistoryViewController* thvc = [[TaskHistoryViewController alloc]init];
            UIBarButtonItem* temporaryBarButtonItem = [[UIBarButtonItem alloc]init];
            
            temporaryBarButtonItem.title = @"返回";
            
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
            [self.navigationController pushViewController:thvc animated:YES];
        }else if (2 == indexPath.row)
        {
            //提现记录
            TiXianHistoryViewController* txvc = [[TiXianHistoryViewController alloc]init];
            UIBarButtonItem* temporaryBarButtonItem = [[UIBarButtonItem alloc]init];
            
            temporaryBarButtonItem.title = @"返回";
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
            [self.navigationController pushViewController:txvc animated:YES];
        }else if (3 == indexPath.row)
        {
            //常见问题
            QuestionViewController* qvc = [[QuestionViewController alloc]init];
            UIBarButtonItem* temporaryBarButtonItem = [[UIBarButtonItem alloc]init];
            
            temporaryBarButtonItem.title = @"返回";
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
            [self.navigationController pushViewController:qvc animated:YES];
        }
    }else if (1 == indexPath.section)
    {
        if (0 == indexPath.row)
        {
            //修改密码
            CHPViewController* chpvc = [[CHPViewController alloc]init];
            
            UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
            
            temporaryBarButtonItem.title=@"返回";
            
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
//            chpvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:chpvc animated:YES];
        }else if (1 == indexPath.row)
        {
            //问题反馈
            FeedBackViewController* fbvc = [[FeedBackViewController alloc]init];
//            UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
//            
//            temporaryBarButtonItem.title=@"返回";
//            
//            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
            [self presentViewController:fbvc animated:YES completion:^{
                
            }];
            
            //            chpvc.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:fbvc animated:YES];
            
        }else if(2 == indexPath.row)
        {
            AboutViewController* avc = [[AboutViewController alloc]init];
            
            UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
            
            temporaryBarButtonItem.title=@"返回";
            
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
            [self.navigationController pushViewController:avc animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
