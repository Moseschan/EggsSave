//
//  FeedBackViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "FeedBackViewController.h"
#import "Masonry.h"
#import "CommonDefine.h"
#import "LoginManager.h"
#import "UIWindow+YzdHUD.h"


@interface FeedBackViewController ()

@property (strong, nonatomic) id feedCommitedObserver;

@end

@implementation FeedBackViewController
{
    UIView*     _headView;
    UITextView* _fankuiView;
    UILabel*    _detailLabel;
    UIButton*   _sendButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:67.f/255 green:67.f/255 blue:67.f/255 alpha:1];
    
    NSNotificationCenter* center = [NSNotificationCenter defaultCenter];
    NSOperationQueue* mainQueue = [NSOperationQueue mainQueue];
    self.feedCommitedObserver = [center addObserverForName:NSUserFeedCommitedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    NSDictionary* dict = note.userInfo;
                                                    
                                                    int result = [dict[@"result"] intValue];
                                                    
                                                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                    
                                                    if (0 == result)
                                                    {
                                                        //提交成功
                                                        [self dismissViewControllerAnimated:YES completion:^{
                                                            
                                                        }];
                                                    }else
                                                    {
                                                        //提交失败
                                                        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提交失败" message:@"由于网络原因，问题反馈提交失败，请稍后再试" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                                        [alert show];
                                                    }
                                                    
                                                }];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    
    [self setUpHeader];
    
    [self setUpTextView];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-5 - height);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [_fankuiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headView.mas_bottom).offset(7);
        make.left.equalTo(self.view).offset(7);
        make.bottom.equalTo(_detailLabel.mas_top).offset(-7);
        make.right.equalTo(self.view).offset(-7);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [_fankuiView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_fankuiView resignFirstResponder];
    
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self.feedCommitedObserver];
}

- (void)setUpTextView
{
    UITextView* tv = [[UITextView alloc]init];
    tv.layer.cornerRadius = 5 ;
    [self.view addSubview:tv];
    _fankuiView = tv;
    _fankuiView.delegate = self;
    
    UILabel* introLabel = [[UILabel alloc]init];
    introLabel.text = @"为了更好为您服务，我们会将您的提供的反馈发给客户支持部门。";
    introLabel.numberOfLines = 0;
    introLabel.textAlignment = NSTextAlignmentCenter;
    introLabel.font = [UIFont systemFontOfSize:14.f];
    [self.view addSubview:introLabel];
    
    _detailLabel = introLabel;
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSString* checkString = _fankuiView.text;
    
    if (![checkString isEqualToString:@""]) {
        [_sendButton setEnabled:YES];
        [_sendButton setTitleColor:[UIColor colorWithRed:40.0/255 green:108.f/255 blue:199.0/255 alpha:1] forState:UIControlStateNormal];
    }else{
        [_sendButton setEnabled:NO];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)setUpHeader
{
    UIView* hView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64.f)];
    hView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:hView];
    
    _headView = hView;
    
    UIView* bView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 44.f)];
    bView.backgroundColor = [UIColor colorWithRed:32.f/255 green:32.f/255 blue:32.f/255 alpha:1];
    [hView addSubview:bView];
    
    UIButton* leftBtn = [[UIButton alloc]init];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorWithRed:40.0/255 green:108.f/255 blue:199.0/255 alpha:1] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [bView addSubview:leftBtn];
    
    UILabel* titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"问题反馈";
    titleLabel.font = [UIFont systemFontOfSize:20.f];
    titleLabel.textColor = [UIColor whiteColor];
    [bView addSubview:titleLabel];
    
    UIButton* rightBtn = [[UIButton alloc]init];
    [rightBtn setTitle:@"发送" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setEnabled:NO];
    [bView addSubview:rightBtn];
    _sendButton = rightBtn;
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(bView);
    }];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(bView);
    }];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.centerY.equalTo(bView);
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)sendAction
{
    DLog(@"sendAction");
    [[LoginManager getInstance]requestCommitQuestions:_fankuiView.text];
    
    [self.view.window showHUDWithText:@"提交中" Type:ShowDismiss Enabled:YES];
}

- (void)cancelAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
