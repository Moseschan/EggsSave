//
//  QuestionViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "QuestionViewController.h"
#import "SKSTableViewCell.h"
#import "Masonry.h"
#import "SKSSubTableViewCell.h"

@interface QuestionViewController ()

@property(nonatomic, strong)NSArray* contents;
@property(nonatomic, strong)NSArray* secContents;

@end

@implementation QuestionViewController

- (NSArray *)secContents
{
    if (!_secContents) {
        _secContents = @[@"账号相关问题",
                         @"新人红包问题",
                         @"做任务赚钱问题",
                         @"师徒体系问题",
                         @"兑换提现问题",
                         @"锁屏问题"
                         ];
    }
    return _secContents;
}

- (NSArray *)contents
{
    if (!_contents) {
        _contents = @[@[@[@"Q：外快宝被退出了，怎么登录？",
                          @"A：如果你已绑定手机，可以用绑定手机号和密码，登录；如果你没有绑定手机，可以一键注册直接登录原有外快宝账号。账号退出时，系统会提示你绑定手机，请牢记绑定手机号和密码，便于下次登录。"],
                        @[@"Q：外快宝ID是外快宝账号吗？",
                          @"A：不是哦，外快宝ID不能用来登录。手机绑定时填写的手机号是外快宝登录账号，完成手机绑定后，可以直接用手机号登录。"],
                        @[@"Q：忘记密码怎么办？",
                          @"A：在登录页面点击忘记密码，通过绑定手机号来重置密码。所以，为了账号安全，请进行手机绑定。"]
                        
                          ],
                      @[@[@"Q：外快宝被退出了，怎么登录？",
                          @"A：如果你已绑定手机，可以用绑定手机号和密码，登录；如果你没有绑定手机，可以一键注册直接登录原有外快宝账号。账号退出时，系统会提示你绑定手机，请牢记绑定手机号和密码，便于下次登录。"],
                        @[@"Q：外快宝ID是外快宝账号吗？",
                          @"A：不是哦，外快宝ID不能用来登录。手机绑定时填写的手机号是外快宝登录账号，完成手机绑定后，可以直接用手机号登录。"],
                        @[@"Q：忘记密码怎么办？",
                          @"A：在登录页面点击忘记密码，通过绑定手机号来重置密码。所以，为了账号安全，请进行手机绑定。"]
                        
                        ],
                      @[@[@"Q：外快宝被退出了，怎么登录？",
                          @"A：如果你已绑定手机，可以用绑定手机号和密码，登录；如果你没有绑定手机，可以一键注册直接登录原有外快宝账号。账号退出时，系统会提示你绑定手机，请牢记绑定手机号和密码，便于下次登录。"],
                        @[@"Q：外快宝ID是外快宝账号吗？",
                          @"A：不是哦，外快宝ID不能用来登录。手机绑定时填写的手机号是外快宝登录账号，完成手机绑定后，可以直接用手机号登录。"],
                        @[@"Q：忘记密码怎么办？",
                          @"A：在登录页面点击忘记密码，通过绑定手机号来重置密码。所以，为了账号安全，请进行手机绑定。"]
                        
                        ],
                      @[@[@"Q：外快宝被退出了，怎么登录？",
                          @"A：如果你已绑定手机，可以用绑定手机号和密码，登录；如果你没有绑定手机，可以一键注册直接登录原有外快宝账号。账号退出时，系统会提示你绑定手机，请牢记绑定手机号和密码，便于下次登录。"],
                        @[@"Q：外快宝ID是外快宝账号吗？",
                          @"A：不是哦，外快宝ID不能用来登录。手机绑定时填写的手机号是外快宝登录账号，完成手机绑定后，可以直接用手机号登录。"],
                        @[@"Q：忘记密码怎么办？",
                          @"A：在登录页面点击忘记密码，通过绑定手机号来重置密码。所以，为了账号安全，请进行手机绑定。"]
                        
                        ],
                      @[@[@"Q：外快宝被退出了，怎么登录？",
                          @"A：如果你已绑定手机，可以用绑定手机号和密码，登录；如果你没有绑定手机，可以一键注册直接登录原有外快宝账号。账号退出时，系统会提示你绑定手机，请牢记绑定手机号和密码，便于下次登录。"],
                        @[@"Q：外快宝ID是外快宝账号吗？",
                          @"A：不是哦，外快宝ID不能用来登录。手机绑定时填写的手机号是外快宝登录账号，完成手机绑定后，可以直接用手机号登录。"],
                        @[@"Q：忘记密码怎么办？",
                          @"A：在登录页面点击忘记密码，通过绑定手机号来重置密码。所以，为了账号安全，请进行手机绑定。"]
                        
                        ],
                      @[@[@"Q：外快宝被退出了，怎么登录？",
                          @"A：如果你已绑定手机，可以用绑定手机号和密码，登录；如果你没有绑定手机，可以一键注册直接登录原有外快宝账号。账号退出时，系统会提示你绑定手机，请牢记绑定手机号和密码，便于下次登录。"],
                        @[@"Q：外快宝ID是外快宝账号吗？",
                          @"A：不是哦，外快宝ID不能用来登录。手机绑定时填写的手机号是外快宝登录账号，完成手机绑定后，可以直接用手机号登录。"],
                        @[@"Q：忘记密码怎么办？",
                          @"A：在登录页面点击忘记密码，通过绑定手机号来重置密码。所以，为了账号安全，请进行手机绑定。"]
                        
                        ]
                      ];
    }
    
    return _contents;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"常见问题";
    
    self.tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.f;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.f;
}

#pragma mark - UITableViewDataSource

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.secContents[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.contents count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    SKSSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[SKSSubTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.block = ^(){
        
    };
    
    QuestionModel* model = [[QuestionModel alloc]init];
    model.q_title = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][0]];
    model.q_details = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][1]];
    
    cell.model = model;
    
    
    return cell;
}



@end
