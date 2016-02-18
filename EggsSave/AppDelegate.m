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
#import "UIWindow+YzdHUD.h"

@interface AppDelegate ()
{
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];

    
//    [KeychainIDFA deleteUSERID];
    NSString* userId = [KeychainIDFA getUserId];
    
    if (!userId) {
        [self showLoginScreen:NO];
    }else
    {
        [self showTabScreen:NO];
    }
    
    return YES;
}

//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
//
//{
//    
//    NSLog(@"DeviceToken: {%@}",deviceToken);
//    
//    //这里进行的操作，是将Device Token发送到服务端
//    
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"DeviceToken:%@",deviceToken] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    
//    [alert show];
//    
//}

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
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
