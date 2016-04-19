//
//  CHPViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 1/7/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "CHPViewController.h"
#import "LoginManager.h"
#import "CommonDefine.h"

@interface CHPViewController ()

@property (strong, nonatomic) id changepwdObserver;

@end

@implementation CHPViewController

- (void)viewWillAppear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    self.changepwdObserver = [center addObserverForName:NSUserChangePasswordNotification object:nil
                                                 queue:mainQueue usingBlock:^(NSNotification *note) {
                                                     
                                                     NSDictionary* dict = note.userInfo;
                                                     
                                                     NSLog(@"change password response dict = %@", dict);
                                                     
                                                     int result = [dict[@"result"] intValue];
                                                     
                                                     if (0 == result) {
                                                         //密码修改成功
                                                         
                                                         UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"密码修改成功" message:@"密码修改成功，现在你可以用新密码登录" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                                                         alert.tag = 201;
                                                         [alert show];
                                                     }else if (-1 == result)
                                                     {
                                                        //密码修改失败
                                                         UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"密码修改失败" message:@"可能由于网络原因，密码修改失败，请稍后再试" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                                                         alert.tag = 202;
                                                         [alert show];
                                                     }else if(-4 == result)
                                                     {
                                                         //旧密码错误
                                                         UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"旧密码有误" message:@"旧密码输入错误，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                                                         alert.tag = 203;
                                                         [alert show];
                                                     }
                                                     
                                                 }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.changepwdObserver];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    self.oldPassTextField.delegate = self;
    self.firstPassTextField.delegate = self;
    self.confirmPassTextField.delegate = self;
    
    self.oldPassTextField.returnKeyType =UIReturnKeyDone;
    self.firstPassTextField.returnKeyType =UIReturnKeyDone;
    self.confirmPassTextField.returnKeyType =UIReturnKeyDone;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *checkString;
    
    if (textField == _oldPassTextField) {
        if (range.location == 15) {
            return NO;
        }else
        {
            if (![string isEqualToString:@""]) {
                checkString=[self.oldPassTextField.text stringByAppendingString:string];
            }else{
                checkString=[checkString stringByDeletingLastPathComponent];
            }
            
            if ([self isPassword:checkString]) {
                DLog(@"密码满足要求");
                
            }else{
                DLog(@"密码不满足要求");
                
            }
            return YES;
        }
    }else if(textField == _firstPassTextField)
    {
        if (range.location == 15) {
            return NO;
        }else
        {
            if (![string isEqualToString:@""]) {
                checkString=[self.firstPassTextField.text stringByAppendingString:string];
            }else{
                checkString=[checkString stringByDeletingLastPathComponent];
            }
            
            if ([self isPassword:checkString]) {
                DLog(@"密码满足要求");
                
            }else{
                
                DLog(@"密码不满足要求");
                
            }
            return YES;
        }
    }
    else if(textField == _confirmPassTextField)
    {
        if (range.location == 15) {
            return NO;
        }else{
            if (![string isEqualToString:@""]) {
                checkString=[self.firstPassTextField.text stringByAppendingString:string];
            }else{
                checkString=[checkString stringByDeletingLastPathComponent];
            }
            
            return YES;
        }
    }
    
    return YES;
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
    [self.oldPassTextField resignFirstResponder];
    [self.firstPassTextField resignFirstResponder];
    [self.confirmPassTextField resignFirstResponder];
}

- (BOOL)isPassword:(NSString *)password
{
    NSString * regex = @"^[A-Za-z0-9]{6,15}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:password] == YES) {
        return YES;
    }else
    {
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changePassword:(id)sender {

    if (![self isPassword:self.oldPassTextField.text]) {
        //旧密码
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"旧密码不满足密码要求，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alert.tag = 101;
        [alert show];
    }else if (![self isPassword:self.firstPassTextField.text])
    {   //新密码
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"新密码不满足密码要求，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alert.tag = 102;
        [alert show];
    }else if(![self isPassword:self.confirmPassTextField.text])
    {   //确认新密码
        if (![self.firstPassTextField.text isEqualToString:self.confirmPassTextField.text]) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"注意" message:@"两次密码输入不一致，请重新输入" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alert.tag = 103;
            [alert show];
        }
    }else
    {
        [[LoginManager getInstance]changeWithOldPass:self.oldPassTextField.text newPass:self.confirmPassTextField.text];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
        [self.oldPassTextField becomeFirstResponder];
    }else if (alertView.tag == 102)
    {
        [self.firstPassTextField becomeFirstResponder];
    }else if (alertView.tag == 103)
    {
        [self.confirmPassTextField becomeFirstResponder];
    }else if (alertView.tag == 201)
    {
        //密码更改成功
        [self.oldPassTextField becomeFirstResponder];
        [self.firstPassTextField becomeFirstResponder];
        [self.confirmPassTextField becomeFirstResponder];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if (alertView.tag == 202)
    {
        //密码更改失败, 重新输入
    }else if(alertView.tag == 203)
    {
        //旧密码错误, 重新输入
    }
}

@end
