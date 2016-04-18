//
//  RechargeViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 3/9/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "RechargeViewController.h"
#import "Masonry.h"
#import "CommonDefine.h"
#import "LoginManager.h"
#import "MJRefresh.h"
#import "WKProgressHUD.h"

@interface RechargeViewController ()

@property (strong, nonatomic)UITableView*    tableView;
@property (strong, nonatomic)NSMutableArray* priceSet;
@property (assign, nonatomic)CGFloat         price;
@property (assign, nonatomic)CGFloat         limitMinPrice;  //受限制的最小的金额
@property (assign, nonatomic)int             limitMinPriceNum;  //最小限制金额处于数组的第几位

@property (strong, nonatomic)UITextField   *zhiAccount;
@property (strong, nonatomic)UITextField   *zhiUser;

@property (strong, nonatomic) id priceSetObserver;

@end

@implementation RechargeViewController
{
    UIView*        _footerView;
    UILabel*       _moneyLabel;
    UILabel*       _needMoneyLabel;
    UIImageView*   _lastpriceImageView;
    UIButton*      _chongzhiBtn;
    UIImageView*   _introImageView;
    
    UIView*        _globalView;
    UIButton*      _selectedBtn;
    
    WKProgressHUD* _hud;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.priceSetObserver = [center addObserverForName:NSUserGetMyMoneyNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    NSDictionary* dict = note.userInfo;
                                                    
                                                    self.price = [dict[@"price"] floatValue];
                                                    
                                                    DLog(@"self.price = %f", self.price);
                                                    _moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.price/100];
                                                    
                                                    NSArray* array = dict[@"priceLimit"];
                                                    
                                                    for (int i=0; i<array.count; ++i) {
                                                        [self.priceSet addObject:[NSString stringWithFormat:@"%@",array[i]]];
                                                    }
                                                    //暂时先不进行排序
                                                    [self.tableView reloadData];
                                                    
                                                    [self.tableView.header endRefreshing];
                                                    
                                                    if (_hud) {
                                                        [_hud dismiss:YES];
                                                        _hud = nil;
                                                    }
                                                    
                                                    self.tableView.header = nil;
                                                    
                                                }];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.priceSetObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付宝充值";
    self.view.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
    
    self.limitMinPrice = 0.0f;
    
    [self setUpPriceSet];
    
    [self setFooterView];
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64.f);
        make.bottom.equalTo(_footerView.mas_top);
    }];
    
    if (!NO_NETWORK) {
        [self setupRefresh];
    }
}

- (void)setupRefresh
{
    // 下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //进行登录操作
        if (_hud) {
            _hud = [WKProgressHUD showInView:self.view withText:@"加载中" animated:YES];
        }
        
        [[LoginManager getInstance] requestPricessSet];
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)setUpPriceSet
{
    self.priceSet = [[NSMutableArray alloc]init];
}

- (void)setFooterView
{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
    [self.view addSubview:view];
    _footerView = view;
    
    UIView* view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor whiteColor];
    [view addSubview:view2];
    
    UILabel* lable1 = [[UILabel alloc]init];
    lable1.text = @"*兑换项和活动均与苹果公司无关";
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = [UIColor colorWithRed:212.f/255 green:212.f/255 blue:212.f/255 alpha:1];
    [view addSubview:lable1];
    
    UILabel* l1 = [[UILabel alloc]init];
    l1.text = @"我的元:";
    [view2 addSubview:l1];
    
    UILabel* l2 = [[UILabel alloc]init];
    l2.text = @"5.57";
    l2.font = [UIFont boldSystemFontOfSize:18.f];
    l2.textColor = [UIColor redColor];
    [view2 addSubview:l2];
    _moneyLabel = l2;
    
    [l2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view2);
        make.right.equalTo(view2).offset(-15);
    }];
    
    [l1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view2);
        make.right.equalTo(l2.mas_left).offset(-7);
    }];
    
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.bottom.equalTo(view2.mas_top).offset(-7);
    }];
    
    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(view);
        make.height.mas_equalTo(44.f);
    }];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.height.mas_equalTo(74);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate



#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* reuseCellId = @"reuseCellID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCellId ];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseCellId];
        
        cell.backgroundColor = [UIColor colorWithRed:242.f/255 green:242.f/255 blue:242.f/255 alpha:1];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //支付宝账号
        UIImageView* v1 = [[UIImageView alloc]init];
        v1.image = [UIImage imageNamed:@"zhi_textview_bg"];
        v1.userInteractionEnabled = YES;
        [cell.contentView addSubview:v1];
        
        UILabel* v11 = [[UILabel alloc]init];
        v11.text = @"支付宝账号";
        v11.font = [UIFont boldSystemFontOfSize:17];
        [v1 addSubview:v11];
        [v11 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1);
            make.left.equalTo(v1).offset(10);
        }];
        
        //textfield
        UITextField* tf1 = [[UITextField alloc]init];
        tf1.placeholder = @"邮箱地址/手机号码";
        tf1.textAlignment = NSTextAlignmentRight;
        [tf1 setReturnKeyType:UIReturnKeyDone];
        [v1 addSubview:tf1];
        _zhiAccount = tf1;
        _zhiAccount.delegate = self;
        
        [tf1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v1);
            make.right.equalTo(v1).offset(-10);
            make.left.equalTo(v11.mas_right).offset(35);
        }];
        
        //收款人姓名
        UIImageView* v2 = [[UIImageView alloc]init];
        v2.image = [UIImage imageNamed:@"zhi_textview_bg"];
        v2.userInteractionEnabled = YES;
        [cell.contentView addSubview:v2];
        _globalView = v2;
        
        UILabel* v21 = [[UILabel alloc]init];
        v21.text = @"收款人姓名";
        v21.font = [UIFont boldSystemFontOfSize:17];
        [v2 addSubview:v21];
        [v21 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v2);
            make.left.equalTo(v2).offset(10);
            
        }];
        
        //textfield
        UITextField* tf2 = [[UITextField alloc]init];
        tf2.placeholder = @"账号对应的认证姓名";
        tf2.textAlignment = NSTextAlignmentRight;
        [tf2 setReturnKeyType:UIReturnKeyDone];
        [v2 addSubview:tf2];
        _zhiUser = tf2;
        _zhiUser.delegate =self;
        
        [tf2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(v2);
            make.right.equalTo(v2).offset(-10);
            make.left.equalTo(v21.mas_right).offset(35);
        }];
        
        UILabel* v3 = [[UILabel alloc]init];
        v3.text = @"需要 10.00元";
        [cell.contentView addSubview:v3];
        _needMoneyLabel = v3;
        
        UIButton* v4 = [[UIButton alloc]init];
        [v4 setBackgroundImage:[UIImage imageNamed:@"zhi_chong_an"] forState:UIControlStateNormal];
        [v4 addTarget:self action:@selector(chongzhiAction) forControlEvents:UIControlEventTouchUpInside];
        [v4 setTitle:@"充值" forState:UIControlStateNormal];
        [cell.contentView addSubview:v4];
        _chongzhiBtn = v4;
        
        UIImageView* v5 = [[UIImageView alloc]init];
        v5.image = [UIImage imageNamed:@"zhi_xuxian"];
        [cell.contentView addSubview:v5];
        _introImageView = v5;
        
        UILabel* v51 = [[UILabel alloc]init];
        v51.text = @"充值的金额将进入你的支付宝余额，可在账单中查询";
        [v51 setFont:[UIFont systemFontOfSize:14]];
        [v51 setAdjustsFontSizeToFitWidth:YES];
        v51.textAlignment = NSTextAlignmentCenter ;
        [v5 addSubview:v51];
        
        
        [v51 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v5);
            make.center.equalTo(v5);
        }];
        
        [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(cell.contentView).offset(10);
            make.right.equalTo(cell.contentView).offset(-10);
        }];
        
        [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView).offset(10);
            make.right.equalTo(cell.contentView).offset(-10);
            make.top.equalTo(v1.mas_bottom).offset(10);
        }];
      
    }
    
    if (self.priceSet.count > 0) {
        for (int i=0; i<(self.priceSet.count - 1)/3 + 1; ++i) {
            for (int j=0; j<3; ++j) {
                
                if ((i*3+j+1) > self.priceSet.count) {
                    break;
                }else
                {
                    UIButton* btn = [[UIButton alloc]init];
                    [cell.contentView addSubview:btn];
                    [btn setBackgroundImage:[UIImage imageNamed:@"zhi_jine_bg"] forState:UIControlStateNormal];
                    [btn setTag:i*3+j];
                    [btn setTitle:[NSString stringWithFormat:@"%@元",self.priceSet[i*3+j]] forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [btn addTarget:self action:@selector(choosePrice:) forControlEvents:UIControlEventTouchUpInside];
                    
                    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        if (j==0) {
                            make.left.equalTo(cell.contentView).offset(10);
                            make.top.equalTo(_globalView.mas_bottom).offset(10);
                            
                        }else if(j == 1)
                        {
                            make.centerX.equalTo(cell.contentView);
                            make.top.equalTo(_globalView);
                        }else
                        {
                            make.right.equalTo(cell.contentView).offset(-10);
                            make.top.equalTo(_globalView);
                        }
                        
                    }];
                    
                    if (i==0 && j==0) {
                        _selectedBtn = btn;
                        [btn setBackgroundImage:[UIImage imageNamed:@"zhi_jine_bg_sel"] forState:UIControlStateNormal];
                    }
                    
                    _globalView = btn;
                }
            }
        }
    }
    
    for (int i=0; i<self.priceSet.count; ++i) {
        CGFloat pri = [self.priceSet[i] floatValue];
        if (self.limitMinPrice > 0 ) {
            if (pri < self.limitMinPrice) {
                self.limitMinPrice = pri;
                
                self.limitMinPriceNum = i;
            }
        }else
        {
            self.limitMinPrice = pri;
        }
    }
    
    if (self.price < self.limitMinPrice) {
        [_chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"zhi_buzu_an"] forState:UIControlStateNormal];
        [_chongzhiBtn setTitle:@"金额不足" forState:UIControlStateNormal];
        [_chongzhiBtn setEnabled:YES];
    }
    
    [_needMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(_globalView.mas_bottom).offset(10);
        make.left.equalTo(cell.contentView).offset(10);
    }];
    
    [_chongzhiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_needMoneyLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [_introImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_chongzhiBtn.mas_bottom).offset(10);
        make.left.equalTo(cell.contentView).offset(10);
        make.right.equalTo(cell.contentView).offset(-10);
        make.bottom.equalTo(cell.contentView).offset(-10);
    }];
    
    return cell;
}

- (void)choosePrice:(id)btn
{
    UIButton* button = btn;
    
    [_selectedBtn setBackgroundImage:[UIImage imageNamed:@"zhi_jine_bg"] forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:@"zhi_jine_bg_sel"] forState:UIControlStateNormal];
    
    _selectedBtn = btn;
    
    NSInteger tag = button.tag;
    
    NSInteger price = [self.priceSet[tag] integerValue];
    
    if (price > self.price) {
        [_chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"zhi_buzu_an"] forState:UIControlStateNormal];
        [_chongzhiBtn setTitle:@"金额不足" forState:UIControlStateNormal];
        [_chongzhiBtn setEnabled:YES];
    }else
    {
        [_chongzhiBtn setBackgroundImage:[UIImage imageNamed:@"zhi_chong_an"] forState:UIControlStateNormal];
        [_chongzhiBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_chongzhiBtn setEnabled:YES];
    }
    
    _needMoneyLabel.text = [NSString stringWithFormat:@"需要 %.2f 元",price*1.f];
    
}

- (void)chongzhiAction
{
    //判断两个textField是否有值
    if ([self.zhiAccount.text isEqual:@""]) //判断密码
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入支付宝账号" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 401;
        [alert show];
    }else if ([self.zhiUser.text isEqual:@""])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入与支付宝账号绑定的用户姓名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag = 501;
        [alert show];
    }else
    {
//        NSInteger tag = _selectedBtn.tag;
//        
//        NSInteger price = [self.priceSet[tag] integerValue];
//        
//        [[LoginManager getInstance] requestTiXianWithAccount:_zhiAccount.text UserName:_zhiUser.text Price:[NSString stringWithFormat:@"%ld",price]];
    }
    
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
