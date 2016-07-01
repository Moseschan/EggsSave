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

//已完成的任务的ID
#define FINISHED_TASK_ID_KEY   @"finishtaskidkey"

/**
 * 随机色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#define TABLEHEADER_COLOR       [UIColor colorWithRed:239.0/255 green:239.0/255 blue:239.0/255 alpha:1]
#define TABLECELL_LINE_COLOR    [UIColor colorWithRed:209.0/255 green:209.0/255 blue:209.0/255 alpha:1]

#define NAVIBARTITLECOLOR [UIColor colorWithRed:121.f/255 green:128.f/255 blue:151.f/255 alpha:1]
#define NAVIBARTINTCOLOR  [UIColor colorWithRed:121.f/255 green:128.f/255 blue:151.f/255 alpha:1]

#define TABLE_TEXT_COLOR  [UIColor colorWithRed:29.f/255 green:29.f/255 blue:29.f/255 alpha:1]

extern NSString* const NSUserDidLoginedNotification;
extern NSString* const NSUserSigninStateNotification;
extern NSString* const NSUserSigninNotification;
extern NSString* const NSUserSignUpNotification;
extern NSString* const NSUserGetMyMoneyNotification;
extern NSString* const NSUserSignUpFailedNotification;
extern NSString* const NSUserLoginFailedNotification;
extern NSString* const NSUserGetTaskSucceedNotification ;  //接任务成功
extern NSString* const NSUserDoTaskCompletedNotification ;  //做任务成功与否
extern NSString* const NSUserGetAuthCodeNotification ;
extern NSString* const NSUserFeedCommitedNotification ;
extern NSString* const NSUserGetDetailInfoNotification;
extern NSString* const NSUserTiXianRecordNotification;
extern NSString* const NSUserTaskRecordNotification ;
extern NSString* const NSUserBindPhoneNotification  ;   //绑定手机号
extern NSString* const NSUserChangePasswordNotification;  //修改密码
extern NSString* const NSUserCommitUserDetailNotification ;   //提交用户详细信息
extern NSString* const NSUserTiXianNotification ;    //提现接口

#define NO_NETWORK   0

#endif /* CommonDefine_h */
