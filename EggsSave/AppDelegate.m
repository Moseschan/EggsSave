//
//  AppDelegate.m
//  EggsSave
//
//  Created by 郭洪军 on 12/9/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonDefine.h"
#import "KeychainIDFA.h"
#import "LoginManager.h"
#import <AVFoundation/AVFoundation.h>
#import "AudioManager.h"
#import "User.h"

NSString* const NSUserDidLoginedNotification       = @"NSUserDidLoginedNotification" ;
NSString* const NSUserSigninStateNotification      = @"NSUserSigninStateNotification";
NSString* const NSUserSigninNotification           = @"NSUserSigninNotification" ;      //签到
NSString* const NSUserGetMyMoneyNotification       = @"NSUserGetMyMoneyNotification";   //剩余金额
NSString* const NSUserSignUpNotification           = @"NSUserSignUpNotification";
NSString* const NSUserSignUpFailedNotification     = @"NSUserSignUpFailedNotification";
NSString* const NSUserLoginFailedNotification      = @"NSUserLoginFailedNotification";
NSString* const NSUserGetTaskSucceedNotification   = @"NSUserGetTaskSucceedNotification";  //接任务成功
NSString* const NSUserDoTaskCompletedNotification  = @"NSUserDoTaskCompletedNotification";  //审核任务成功与否
NSString* const NSUserGetAuthCodeNotification      = @"NSUserGetAuthCodeNotification" ; //获取验证码
NSString* const NSUserFeedCommitedNotification     = @"NSUserFeedCommitedNotification";  //问题反馈提交成功
NSString* const NSUserGetDetailInfoNotification    = @"NSUserGetDetailInfoNotification"; //获取用户详细信息
NSString* const NSUserTiXianRecordNotification     = @"NSUserTiXianRecordNotification";//提现记录接口
NSString* const NSUserTaskRecordNotification       = @"NSUserTaskRecordNotification"; //任务记录
NSString* const NSUserBindPhoneNotification        = @"NSUserBindPhoneNotification";  //绑定手机号
NSString* const NSUserChangePasswordNotification   = @"NSUserChangePasswordNotification"; //修改密码接口
NSString* const NSUserCommitUserDetailNotification = @"NSUserCommitUserDetailNotification"; //提交用户详细信息

@interface AppDelegate ()
{
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers  error:nil];
    
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
//    [KeychainIDFA deleteUSERID];
    NSString* userId = [KeychainIDFA getUserId];
    
    User* u = [User getInstance];
    u.userID = userId;
    
    if (!userId) {
        [self showLoginScreen:NO];
    }else
    {
        [self showTabScreen:NO];
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[AudioManager getInstance]play];

   
    return YES;
}

- (void)showTabScreen:(BOOL)animated
{
    UITabBarController* viewController = InstFirstVC(@"Main");
    [self.window setRootViewController:viewController];
    [self.window makeKeyAndVisible];
}

- (void)showLoginScreen:(BOOL)animated
{
    UIViewController* loginVC = InstFirstVC(@"Login");
    [self.window setRootViewController:loginVC];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application{
    
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    });
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
 
}

- (void)applicationWillTerminate:(UIApplication *)application {
  
}

@end
