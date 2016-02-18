//
//  CHPViewController.m
//  EggsSave
//
//  Created by 郭洪军 on 1/7/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "CHPViewController.h"
#import "LoginManager.h"

@interface CHPViewController ()

@end

@implementation CHPViewController

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
    }
}

@end
