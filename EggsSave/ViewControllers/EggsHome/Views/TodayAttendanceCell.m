//
//  TodayAttendanceCell.m
//  EggsSave
//
//  Created by 郭洪军 on 3/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "TodayAttendanceCell.h"
#import "Masonry.h"
#import "ZDProgressView.h"
#import "DataManager.h"
#import "CommonDefine.h"

@interface TodayAttendanceCell()

@property (strong, nonatomic) id qiandaoObserver;
@property (nonatomic,strong) ZDProgressView *zdProgressView;


@end

@implementation TodayAttendanceCell
{
    UIImageView*     _editImageView;
    UILabel*         _leftDayLabel;
    UIButton*        _signinBtn;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone ;
        
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    UIImageView* v1 = [[UIImageView alloc]init];
    v1.image = [UIImage imageNamed:@"home_attendance"];
    [self.contentView addSubview:v1];
    _editImageView = v1;
    
    UILabel* v2 = [[UILabel alloc]init];
    v2.text = @"还需连续签到30天就有机会获得红包";
    v2.textColor = [UIColor grayColor];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:v2.text];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 2)];
    v2.attributedText = string;
    
    [self.contentView addSubview:v2];
    v2.font = [UIFont systemFontOfSize:10];
    _leftDayLabel = v2;
    
    [self zdProgressViewInit];
    
    UIButton* v4 = [[UIButton alloc]init];
    [v4 setImage:[UIImage imageNamed:@"home_signin"] forState:UIControlStateNormal];
    [self.contentView addSubview:v4];
    [v4 addTarget:self action:@selector(qiandao) forControlEvents:UIControlEventTouchUpInside];
    _signinBtn = v4;
    
    //添加约束
    [_editImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
    }];
    
    [_leftDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_editImageView.mas_right).offset(5);
        make.top.mas_equalTo(5);
    }];
    
    [_signinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.equalTo(self.contentView);
    }];
}

#pragma mark - zdProgressViewInit
- (void)zdProgressViewInit
{
    self.zdProgressView = [[ZDProgressView alloc] initWithFrame:CGRectMake(60, 200, 160, 10)];
    self.zdProgressView.progress = 0;
    self.zdProgressView.text = @"0%";
    self.zdProgressView.noColor = [UIColor whiteColor];
    self.zdProgressView.prsColor = [UIColor colorWithRed:0 green:174.f/255 blue:102.f/255 alpha:1];
    [self.contentView addSubview:self.zdProgressView];
    
    [_zdProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftDayLabel);
        make.top.equalTo(_leftDayLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-7);
        make.size.mas_equalTo(CGSizeMake(160, 10));
    }];
   
}

- (void)setStatus
{
    int status = [[DataManager getInstance] getSignStatus];
    
    if (status == 2) {
        //已经签到
        [_signinBtn setImage:[UIImage imageNamed:@"home_signed"] forState:UIControlStateNormal];
        [_signinBtn setEnabled:NO];
    }else if (status == 3)
    {
        //还未签到
        [_signinBtn setImage:[UIImage imageNamed:@"home_signin"] forState:UIControlStateNormal];
    }
    
    //签到天数
    int days = [[DataManager getInstance] getSignDays];
    
    [_zdProgressView setProgress:days/30.f];
    _zdProgressView.text = [NSString stringWithFormat:@"%.2f%%",days/30.f * 100];
    
    if (days > 20) {
        _leftDayLabel.text = [NSString stringWithFormat:@"还需连续签到%d天就有机会获得红包",30-days];
        _leftDayLabel.textColor = [UIColor grayColor];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_leftDayLabel.text];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 1)];
        
        _leftDayLabel.attributedText = string;
    }else
    {
        _leftDayLabel.text = [NSString stringWithFormat:@"还需连续签到%d天就有机会获得红包",30-days];
        _leftDayLabel.textColor = [UIColor grayColor];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_leftDayLabel.text];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 2)];
        
        _leftDayLabel.attributedText = string;
    }
}

- (void)qiandao
{
    if (self.qiandaoAction) {
        self.qiandaoAction();
    }
    
    //注册一个监听者，监听数据获取完毕
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    
    __weak __typeof(center)weakCenter = center;
    self.qiandaoObserver = [center addObserverForName:NSUserSigninNotification object:nil
                                                     queue:mainQueue usingBlock:^(NSNotification *note) {
                                                         
                                                         NSDictionary* dict = note.userInfo;
                                                         
                                                         int days = [dict[@"signCount"] intValue];
                                                         
                                                         [[DataManager getInstance] setSignDays:days];
                                                         
                                                         if (days < 0) {
                                                             //签到失败 可以弹出框提醒
                                                         }else
                                                         {
                                                             [_signinBtn setImage:[UIImage imageNamed:@"home_signed"] forState:UIControlStateNormal];
                                                             [_signinBtn setEnabled:NO];
                                                             
                                                             [_zdProgressView setProgress:days/30.f];
                                                             _zdProgressView.text = [NSString stringWithFormat:@"%.2f%%",days/30.f * 100];
                                                             
                                                             if (days > 20) {
                                                                 _leftDayLabel.text = [NSString stringWithFormat:@"还需连续签到%d天就有机会获得红包",30-days];
                                                                 _leftDayLabel.textColor = [UIColor grayColor];
                                                                 NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_leftDayLabel.text];
                                                                 [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 1)];
                                                                 
                                                                 _leftDayLabel.attributedText = string;
                                                             }else
                                                             {
                                                                 _leftDayLabel.text = [NSString stringWithFormat:@"还需连续签到%d天就有机会获得红包",30-days];
                                                                 _leftDayLabel.textColor = [UIColor grayColor];
                                                                 NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_leftDayLabel.text];
                                                                 [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6, 2)];
                                                                 
                                                                 _leftDayLabel.attributedText = string;
                                                             }
                                                         }
                                                         
                                                         [weakCenter removeObserver:self.qiandaoObserver];
                                                         
                                                     }];
    
}

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
