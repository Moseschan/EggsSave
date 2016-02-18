//
//  ShiTuViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 2/16/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "ShiTuViewController.h"
#import "CommonDefine.h"
#import "Masonry.h"

@interface ShiTuViewController ()

@end

@implementation ShiTuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义 tableHeaderView;
    UIView* tHeadView = [self createTableHeaderView];
    self.tableView.tableHeaderView = tHeadView;
    
    self.tableView.allowsSelection = NO;
}

- (UIView *)createTableHeaderView
{
    UIView* thView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 142)];
    thView.backgroundColor = [UIColor colorWithRed:212.f/255.f green:0 blue:0 alpha:1];
    
    UIView* hLine = [[UIView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_HEIGHT, 1)];
    hLine.backgroundColor = [UIColor grayColor];
    [thView addSubview:hLine];
    
    UIView* vLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 65, 1, 142-65)];
    vLine.backgroundColor = [UIColor grayColor];
    [thView addSubview:vLine];
    
    //306x42  st_allincom
    UIImageView* allincomeImgView = [[UIImageView alloc]init];
    allincomeImgView.image = [UIImage imageNamed:@"st_allincom"];
    [thView addSubview:allincomeImgView];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentLeft Text:@"徒弟个数" maker:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine).with.offset(12.f);
        make.left.equalTo(thView).with.offset(12.f);
    }];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentRight Text:@"0人" maker:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine).with.offset(12.f);
        make.right.equalTo(vLine).with.offset(-12.f);
    }];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentLeft Text:@"徒弟奖励" maker:^(MASConstraintMaker *make) {
        make.bottom.equalTo(thView).with.offset(-12.f);
        make.left.equalTo(thView).with.offset(12.f);
    }];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentLeft Text:@"20%" maker:^(MASConstraintMaker *make) {
        make.bottom.equalTo(thView).with.offset(-12.f);
        make.right.equalTo(vLine).with.offset(-12.f);
    }];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentLeft Text:@"徒孙个数" maker:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine).with.offset(12.f);
        make.left.equalTo(vLine).with.offset(12.f);
    }];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentRight Text:@"0人" maker:^(MASConstraintMaker *make) {
        make.top.equalTo(hLine).with.offset(12.f);
        make.right.equalTo(thView).with.offset(-12.f);
    }];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentLeft Text:@"徒孙奖励" maker:^(MASConstraintMaker *make) {
        make.bottom.equalTo(thView).with.offset(-12.f);
        make.left.equalTo(vLine).with.offset(12.f);
    }];
    
    [self createLabelWithSuperView:thView TextColor:[UIColor whiteColor] TextAlign:NSTextAlignmentLeft Text:@"10%" maker:^(MASConstraintMaker *make) {
        make.bottom.equalTo(thView).with.offset(-12.f);
        make.right.equalTo(thView).with.offset(-12.f);
    }];
    
    [allincomeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(thView);
        make.top.equalTo(thView).with.offset(10);
        make.left.equalTo(thView).with.offset(10);
        make.bottom.equalTo(hLine).with.offset(-10);
        make.right.equalTo(thView).with.offset(-10);
    }];
    
    return thView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section) {
        if (0 == indexPath.row)
        {
            return 128.f;
        }else
        {
            return 65.f;
        }
    }else if (1 == indexPath.section)
    {
        return 65.f;
    }else
    {
        return 44.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 2;
    }else if(1 == section)
    {
        return 1;
    }else
    {
        return 2;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseCell = @"reuseCell";     //  0
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell];      //   1
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: reuseCell];    //  2
    }
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            UILabel* bbLb = [[UILabel alloc]init];
            bbLb.numberOfLines = 0;
            [bbLb setFont:[UIFont systemFontOfSize:14]];
            bbLb.text = @"免费发送4元红包给好友，好友安装成功即可成为徒弟，你可以获得徒弟赚得收入的20%奖励";
            [cell.contentView addSubview:bbLb];
            [bbLb mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(18);
                make.left.equalTo(cell.contentView).with.offset(10);
                make.right.equalTo(cell.contentView).with.offset(-10);
            }];
            
            UIButton* buBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [buBtn setImage:[UIImage imageNamed:@"tijiaokuang"] forState:UIControlStateNormal];
            [cell.contentView addSubview:buBtn];
            [buBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40.f);
                make.left.equalTo(cell.contentView).with.offset(10);
                make.bottom.right.equalTo(cell.contentView).with.offset(-10);
            }];
            
            UILabel* bLa = [[UILabel alloc]init];
            bLa.text = @"分享好友收徒弟";
            bLa.textColor = [UIColor whiteColor];
            [buBtn addSubview:bLa];
            [bLa mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.centerY.equalTo(buBtn);
            }];
            
        }else
        {
            UIImageView* allincomeImgView = [[UIImageView alloc]init];
            allincomeImgView.image = [UIImage imageNamed:@"st_huodong"];
            [cell.contentView addSubview:allincomeImgView];
            
            [allincomeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell.contentView).with.offset(5);
                make.left.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView).with.offset(-5);
                make.right.equalTo(cell.contentView);
            }];
        }
    }else if (1 == indexPath.section)
    {
        UILabel* bLa1 = [[UILabel alloc]init];
        bLa1.text = @"你还没有收过徒弟";
        bLa1.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:bLa1];
        [bLa1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.contentView).with.offset(14.f);
            make.centerX.equalTo(cell.contentView);
        }];
        
        UILabel* bLa2 = [[UILabel alloc]init];
        bLa2.text = @"躺着赚钱全靠徒弟，赶紧收徒吧!";
        bLa2.textColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:bLa2];
        [bLa2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(bLa1).with.offset(18.f);
            make.centerX.equalTo(cell.contentView);
        }];
    }else
    {
        if (0 == indexPath.row) {
            cell.textLabel.text = @"为什么要收徒弟？ (必读)）";
        }else
        {
            cell.textLabel.text = @"如何收取更多徒弟？ (必读)";
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section || 1 == section) {
        return 40;
    }else
    {
        return 10;
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        UIView* shView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        shView.backgroundColor = [UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:1];
        
        UILabel* sectionLabel = [[UILabel alloc]init];
        sectionLabel.text = @"收徒方式";
        sectionLabel.textAlignment = NSTextAlignmentLeft;
        [shView addSubview:sectionLabel];
        [sectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(shView);
            make.left.equalTo(shView).with.offset(12);
        }];
        
        UIButton* shoutuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [shoutuBtn setTitle:@"面对面收徒" forState:UIControlStateNormal];
        [shoutuBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [shoutuBtn addTarget:self action:@selector(faceTofaceShoutu) forControlEvents:UIControlEventTouchUpInside];
        [shView addSubview:shoutuBtn];
        [shoutuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(shView);
            make.right.equalTo(shView).with.offset(-12);
        }];
        
        return shView;
    }else if(1 == section)
    {
        UIView* shView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        shView.backgroundColor = [UIColor colorWithRed:242.f/255.f green:242.f/255.f blue:242.f/255.f alpha:1];
        //sectionLabel
        [self createLabelWithSuperView:shView TextColor:[UIColor blackColor] TextAlign:NSTextAlignmentLeft Text:@"最新徒弟" maker:^(MASConstraintMaker *make) {
            make.centerY.equalTo(shView);
            make.left.equalTo(shView).with.offset(12);
        }];
        
        return shView;
    }else
    {
        return NULL;
    }
    
    return NULL;
}

- (void)faceTofaceShoutu
{
    DLog(@"faceTofaceShouTo");
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

@end
