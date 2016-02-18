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

@interface MyViewController ()
{
    MyTableViewHeader* mHeadView;
}

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(self)weakSelf = self;
    
    mHeadView = [[MyTableViewHeader alloc]init];
    mHeadView.mthSetMessage = ^(){
        PersonalMessageViewController* pmvc = InstFirstVC(@"PersonalMessageViewController");
        
        UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
        
        temporaryBarButtonItem.title=@"返回";
        
        weakSelf.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        
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
        return 2;
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
            cell.titleLabel.text = @"兑换记录";
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
            cell.titleLabel.text = @"退出账号";
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
            
            [self.navigationController pushViewController:bpvc animated:YES];
        }else if (1 == indexPath.row)
        {
            //
        }
    }else if (1 == indexPath.section)
    {
        if (1 == indexPath.row) {
            //退出账号
        } else if (0 == indexPath.row)
        {
            //修改密码
            CHPViewController* chpvc = [[CHPViewController alloc]init];
            
            UIBarButtonItem *temporaryBarButtonItem=[[UIBarButtonItem alloc] init];
            
            temporaryBarButtonItem.title=@"返回";
            
            self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
            
            [self.navigationController pushViewController:chpvc animated:YES];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
