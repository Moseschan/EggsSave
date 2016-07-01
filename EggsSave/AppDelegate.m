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
#import "ProcessManager.h"


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
    //测试加入白名单
//    [[ProcessManager getInstance] writeToWhiteList:@"com.husor.beibei"];
    
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
