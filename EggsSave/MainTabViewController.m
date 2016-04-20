//
//  MainTabViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 12/10/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "MainTabViewController.h"
#import "CommonDefine.h"

@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController* homeVC = InstFirstVC(@"EggsHome");
    UIViewController* cashVC = InstFirstVC(@"GetCash");
    UIViewController* taskVC = InstFirstVC(@"Task");
    UIViewController* shituVC = InstFirstVC(@"ShiTu");
    UIViewController* myVC = InstFirstVC(@"My");
    
    homeVC.tabBarItem.title=@"首页";
    cashVC.tabBarItem.title=@"提现";
    taskVC.tabBarItem.title=@"任务";
    shituVC.tabBarItem.title=@"师徒";
    myVC.tabBarItem.title=@"我的";
    
    homeVC.tabBarItem.image=[UIImage imageNamed:@"icon_home"];
    cashVC.tabBarItem.image=[UIImage imageNamed:@"icon_zq"];
    taskVC.tabBarItem.image=[UIImage imageNamed:@"icon_exchage"];
    shituVC.tabBarItem.image=[UIImage imageNamed:@"icon_st"];
    myVC.tabBarItem.image=[UIImage imageNamed:@"icon_my"];
    
    [self setViewControllers:@[homeVC, cashVC, taskVC, myVC]];
    
//    [self setSelectedIndex:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
