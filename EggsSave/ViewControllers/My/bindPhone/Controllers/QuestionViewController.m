 //
//  QuestionViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "QuestionViewController.h"
#import "Masonry.h"
#import "GroupCell.h"
#import "QuestionGroup.h"
#import "Answer.h"

@interface QuestionViewController ()

@property(nonatomic, strong)NSArray* contents;
@property(nonatomic, strong)NSArray* secContents;

@property(nonatomic, strong)NSMutableDictionary* sections;

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

- (NSMutableDictionary *)sections
{
    if (!_sections) {
        _sections = [[NSMutableDictionary alloc]init];
        
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"questions" ofType:@"plist"];
        NSDictionary* dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
        
        for (NSInteger j=0; j<_secContents.count; ++j) {
            NSString* title = _secContents[j];
            
            NSDictionary* dic1 = [dic objectForKey:title];
            
            NSArray* a1 = [dic1 allKeys];
            
            NSMutableArray* tempArray = [[NSMutableArray alloc]init];
            
            for (NSInteger k=0; k<a1.count; ++k) {
                
                QuestionGroup* t_qg = [QuestionGroup new];
                t_qg.groupName = a1[k];
                
                NSMutableArray* groupA = [NSMutableArray array];
                
                NSArray* arr = [dic1 objectForKey:a1[k]];
                for (NSInteger i=0; i<arr.count; ++i) {
                    Answer* t_a = [Answer new];
                    t_a.details = arr[i];
                    
                    [groupA addObject:t_a];
                }
                t_qg.answersArray = groupA;
                
                [tempArray addObject:t_qg];
            }
            
            [_sections setObject:tempArray forKey:title];
        }
        
    }
    
    return _sections;
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
    
    [self secContents];
    [self contents];
    [self sections];
    
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
    NSMutableArray* tarry = [self.sections objectForKey:_secContents[section]] ;
    
    return tarry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    GroupCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
    {
        cell = [[GroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSMutableArray* tarry = [self.sections objectForKey:_secContents[indexPath.section]] ;
    
    id object = tarry[indexPath.row];
    
    if ([object isKindOfClass:[QuestionGroup class]]) {
        QuestionGroup* temp_qg = object;
        [cell setInfoWithQuestionGroup:temp_qg];
        
        if (temp_qg.isOpen) {
            cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
        }else
        {
            cell.accessoryView.transform = CGAffineTransformMakeRotation(0);
        }
        
    }else if ([object isKindOfClass:[Answer class]])
    {
        Answer* temp_a = object;
        [cell setInfoWithAnswer:temp_a];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* arr1 = [self.sections objectForKey:[_secContents objectAtIndex:indexPath.section]];
    
    id object = [arr1 objectAtIndex:indexPath.row];
    
    GroupCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ([object isKindOfClass:[QuestionGroup class]] /*需要打开列表*/) {
        
        QuestionGroup* temp_qg = object;
        temp_qg.isOpen = !temp_qg.isOpen;
        NSArray* arr2 = temp_qg.answersArray;
        
        if (temp_qg.isOpen) {
            //插入几行
            NSInteger local = indexPath.row;
            NSInteger length = arr2.count;
            NSRange range = {local+1, length} ;
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            NSMutableArray* subRows = [NSMutableArray array];
            
            for (NSInteger i=0; i<arr2.count; ++i) {
                [subRows addObject:arr2[i]];
            }
            
            NSMutableArray* tarry = [self.sections objectForKey:_secContents[indexPath.section]] ;
            [tarry insertObjects:subRows atIndexes:indexSet];
            
            NSMutableArray* insertPaths = [NSMutableArray array] ;
            
            id object = [tarry objectAtIndex:indexPath.row];
            NSInteger insertItemIndex = [tarry indexOfObject:object];
            
            for (int i= 0;i<length;i++)
            {
                NSIndexPath *indexPth = [NSIndexPath indexPathForRow:++insertItemIndex inSection:indexPath.section];
                [insertPaths addObject:indexPth];
            }
            [self.tableView insertRowsAtIndexPaths:insertPaths withRowAnimation:UITableViewRowAnimationTop];
            
            [UIView animateWithDuration:0.2 animations:^{
                    cell.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
            } completion:^(BOOL finished) {
                
            }];
        }else
        {
            NSInteger local = indexPath.row;
            NSInteger lenth = arr2.count;
            NSRange range = {local+1,lenth};
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            NSMutableArray* tarry = [self.sections objectForKey:_secContents[indexPath.section]] ;
            [tarry removeObjectsAtIndexes:indexSet];
            NSMutableArray *insertPaths = [NSMutableArray array];
            NSInteger deleteItemIndex = [tarry indexOfObject:object];
            for (int i= 0;i<lenth;i++)
            {
                NSIndexPath *indexPth = [NSIndexPath indexPathForRow:++deleteItemIndex inSection:indexPath.section];
                [insertPaths addObject:indexPth];
            }
            [self.tableView deleteRowsAtIndexPaths:insertPaths withRowAnimation:UITableViewRowAnimationTop];
            
            [UIView animateWithDuration:0.2 animations:^{
                cell.accessoryView.transform = CGAffineTransformMakeRotation(0);
             } completion:^(BOOL finished) {
                 
             }];
        }
        
        
    }else
    {
        //是answer行，不需要进行操作
    }
    
}



@end
