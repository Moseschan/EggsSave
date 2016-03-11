//
//  GetCashViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 2/18/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "GetCashViewController.h"
#import "Masonry.h"
#import "RechargeViewController.h"
#import "CommonDefine.h"
#import "LoginManager.h"
#import "MJRefresh.h"
#import "UIWindow+YzdHUD.h"
#import "DataManager.h"

@interface GetCashViewController ()

@property (strong, nonatomic) id priceSetObserver;

@end

@implementation GetCashViewController
{
    UILabel* _priceLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.priceSetObserver = [center addObserverForName:NSUserGetMyMoneyNotification object:nil
                                                 queue:mainQueue usingBlock:^(NSNotification *note) {
                                                     
                                                     NSDictionary* dict = note.userInfo;
                                                     
                                                     float price = [dict[@"price"] floatValue];
                                                     
                                                     _priceLabel.text = [NSString stringWithFormat:@"%.2f", price];
                                                     
                                                     [self.tableView.header endRefreshing];
                                                     
                                                     [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                     
                                                     self.tableView.header = nil;
                                                     
                                                 }];
    
    _priceLabel.text = [NSString stringWithFormat:@"%.2f",[[DataManager getInstance] getMyMoney]] ;
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.priceSetObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:NAVIBARTITLECOLOR};
    
    self.navigationController.navigationBar.tintColor = NAVIBARTINTCOLOR;
    
    self.view.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
    
    if (!NO_NETWORK) {
        [self setupRefresh];
    }
}

- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行登录操作
        
        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        
        [[LoginManager getInstance] requestPricessSet];
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }else
    {
        return 1;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* reuseCell = @"reuseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: reuseCell];
    }
    
    if (0 == indexPath.section) {
        
        UILabel* bbLb = [[UILabel alloc]init];
        [bbLb setFont:[UIFont systemFontOfSize:16]];
        bbLb.text = @"当前可兑余额:";
        [cell.contentView addSubview:bbLb];
        [bbLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.left.equalTo(cell.contentView).with.offset(10);
        }];
        
        UILabel* bLa = [[UILabel alloc]init];
        [bLa setFont:[UIFont systemFontOfSize:20]];
        bLa.text = @"4.03";
        bLa.textColor = [UIColor redColor];
        [cell.contentView addSubview:bLa];
        _priceLabel = bLa;
        [bLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bbLb);
            make.left.equalTo(bbLb.mas_right).with.offset(8);
        }];
        
        UILabel* baLa = [[UILabel alloc]init];
        [baLa setFont:[UIFont systemFontOfSize:16]];
        baLa.text = @"元";
        baLa.textColor = [UIColor redColor];
        [cell.contentView addSubview:baLa];
        [baLa mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(bbLb);
            make.left.equalTo(bLa.mas_right).with.offset(5);
        }];
        
        UIView* thLine = [[UIView alloc]init];
        [thLine setBackgroundColor:[UIColor colorWithRed:185.f/255.f green:185.f/255.f blue:185.f/255.f alpha:0.6]];
        [cell.contentView addSubview:thLine];
        [thLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1.f);
            make.top.left.right.equalTo(cell.contentView);
        }];
        
        UIView* bhLine = [[UIView alloc]init];
        [bhLine setBackgroundColor:[UIColor colorWithRed:185.f/255.f green:185.f/255.f blue:185.f/255.f alpha:0.6]];
        [cell.contentView addSubview:bhLine];
        [bhLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1.f);
            make.bottom.left.right.equalTo(cell.contentView);
        }];
        
    }else if (1 == indexPath.section)
    {
        if (0 == indexPath.row) {
//            UILabel* bbLb = [[UILabel alloc]init];
//            bbLb.text = @"支付宝提现";
//            [cell.contentView addSubview:bbLb];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.imageView.image = [UIImage imageNamed:@"zhi_icon"];
            cell.textLabel.text = @"支付宝提现";
            
//            [bbLb mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerY.mas_equalTo(cell.contentView);
//                make.left.mas_equalTo(cell.contentView).with.offset(10);
//            }];
            
            UIView* thLine = [[UIView alloc]init];
            [thLine setBackgroundColor:[UIColor colorWithRed:185.f/255.f green:185.f/255.f blue:185.f/255.f alpha:0.6]];
            [cell.contentView addSubview:thLine];
            [thLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@1.f);
                make.top.left.right.equalTo(cell.contentView);
            }];
        }else
        {
            UILabel* bbLb = [[UILabel alloc]init];
            bbLb.text = @"兑换抢购币";
            [cell.contentView addSubview:bbLb];
            [bbLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.contentView);
                make.left.mas_equalTo(cell.contentView).with.offset(10);
            }];
            
            UIView* bhLine = [[UIView alloc]init];
            [bhLine setBackgroundColor:[UIColor colorWithRed:185.f/255.f green:185.f/255.f blue:185.f/255.f alpha:0.6]];
            [cell.contentView addSubview:bhLine];
            [bhLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@1.f);
                make.bottom.left.right.equalTo(cell.contentView);
            }];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section ) {
        return 0;
    }else
    {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        return 54.f;
    }
    
    return 70.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UILabel*)createLabelWithSuperView:(UIView*)superView TextColor:(UIColor*)color TextAlign:(NSTextAlignment )alignment Text:(NSString*)text maker:(void(^)(MASConstraintMaker *make))block
{
    UILabel* label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    [superView addSubview:label];
    [label mas_makeConstraints:block];
    
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RechargeViewController* rechargeVC = [[RechargeViewController alloc]init];
    
    rechargeVC.hidesBottomBarWhenPushed = YES;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:rechargeVC animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
