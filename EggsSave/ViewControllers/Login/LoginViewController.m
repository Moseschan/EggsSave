//
//  LoginViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 12/21/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "CommonDefine.h"
#import "AFNetworking.h"
#import "User.h"
#import "EncryptUtils.h"
#import "HashUtils.h"
#import "KeychainIDFA.h"
#import <string.h>
#import "TasksManager.h"
#import "LoginManager.h"
#import "UIWindow+YzdHUD.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) id loginedObserver;
@property (strong, nonatomic) id signupObserver;
@property (strong, nonatomic) id signupFailedObserver;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
}

- (void)viewWillAppear:(BOOL)animated
{
    //注册一个监听者，监听数据获取完毕
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.loginedObserver = [center addObserverForName:NSUserDidLoginedNotification object:nil
                                                queue:mainQueue usingBlock:^(NSNotification *note) {
                                                    
                                                    DLog(@"The user's did logined");
                                                    
                                                    [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                    //注册成功
                                                    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                                                    UITabBarController* viewController = InstFirstVC(@"Main");
                                                    [appDelegate.window setRootViewController:viewController];
                                                    [appDelegate.window makeKeyAndVisible];
                                                    
                                                }];
    
    self.signupObserver = [center addObserverForName:NSUserSignUpNotification object:nil
                                               queue:mainQueue usingBlock:^(NSNotification *note) {
                                                   
                                                   DLog(@"The user sign up succeed");
                                                   
                                                   [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                   //注册成功
                                                   AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                                                   UITabBarController* viewController = InstFirstVC(@"Main");
                                                   [appDelegate.window setRootViewController:viewController];
                                                   [appDelegate.window makeKeyAndVisible];
                                                   
                                               }];
    
    self.signupFailedObserver = [center addObserverForName:NSUserSignUpFailedNotification object:nil
                                               queue:mainQueue usingBlock:^(NSNotification *note) {
                                                   
                                                   DLog(@"The user sign up failed");
                                                   
                                                   [self.view.window showHUDWithText:nil Type:ShowDismiss Enabled:YES];
                                                   //注册失败
                                                   UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"注册期间出现问题，请再次尝试注册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                                                   [alert show];
                                                   
                                               }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.loginedObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.signupObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.signupFailedObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    
    //如果点击登录按钮进行登录,
    if ([_nameTextField.text  isEqual: @""]) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入用户绑定的手机号/用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if([_passwordTextField.text  isEqual: @""])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"请输入用户密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else
    {
        [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
        
        LoginManager* manager = [LoginManager getInstance];
        [manager login];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0)
{
    
}

//点击return 按钮 去掉
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.nameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)forgetPassword:(id)sender {
    
    DLog(@"忘记密码！！！");
}

- (IBAction)signUp:(id)sender {
    [self.view.window showHUDWithText:@"加载中" Type:ShowLoading Enabled:YES];
    
    [[LoginManager getInstance] signUp];
}


@end
