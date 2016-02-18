//
//  CommonDefine.h
//  EggsSave
//
//  Created by 郭洪军 on 12/10/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define DESIGN_SCREEN_WIDTH  320.0f

#define InstFirstVC(stID)   [[UIStoryboard storyboardWithName:(stID) bundle:nil] instantiateInitialViewController]

#define DOMAIN_URL @"123.57.85.254:8080"

/**
 * 随机色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

extern NSString* const NSUserDidLoginedNotification;
extern NSString* const NSUserSignUpNotification;
extern NSString* const NSUserSignUpFailedNotification;
extern NSString* const NSUserLoginFailedNotification;
extern NSString* const NSUserGetTaskSucceedNotification ;  //接任务成功
extern NSString* const NSUserDoTaskFailedNotification ;  //接任务成功
extern NSString* const NSUserGetAuthCodeNotification ;

#define NO_NETWORK   0

#endif /* CommonDefine_h */
