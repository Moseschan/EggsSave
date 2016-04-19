//
//  BindedPhoneViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 4/18/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "BindedPhoneViewController.h"
#import "Masonry.h"
#import "CommonDefine.h"

@interface BindedPhoneViewController ()

@end

@implementation BindedPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView* scrollView = [[UIScrollView alloc]init];
    scrollView.backgroundColor = [UIColor colorWithRed:(245 / 255.0) green:(245 / 255.0) blue:(245 / 255.0) alpha:1];
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT-44-48-20);
//    scrollView.alwaysBounceVertical = YES;
    
    UIImageView *phoneImageView = [[UIImageView alloc]init];
    phoneImageView.image = [UIImage imageNamed:@"bp_phone"];
    [scrollView addSubview:phoneImageView];
    
    [phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(125-64);
        make.centerX.equalTo(scrollView);
    }];
    
    UILabel* phoneNumLabel = [[UILabel alloc]init];
    phoneNumLabel.text = [NSString stringWithFormat:@"你绑定的手机号：%@", self.phoneNum];
    phoneNumLabel.font = [UIFont systemFontOfSize:18];
    [scrollView addSubview:phoneNumLabel];
    
    [phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(scrollView);
        make.top.equalTo(phoneImageView.mas_bottom).offset(20);
    }];

    UILabel* detailLabel = [[UILabel alloc]init];
    detailLabel.text = @"手机号即登录账号，为了保证账号安全和顺利提现，请牢记！";
    detailLabel.numberOfLines = 0;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor lightGrayColor];
    detailLabel.font = [UIFont systemFontOfSize:16];
    [scrollView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumLabel.mas_bottom).offset(25);
        make.left.equalTo(scrollView).offset(10);
        make.centerX.equalTo(scrollView);
    }];
    
    [self.view addSubview:scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
