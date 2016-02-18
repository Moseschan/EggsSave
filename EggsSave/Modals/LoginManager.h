//
//  LoginManager.h
//  EggsSave
//
//  Created by 郭洪军 on 12/24/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+ (id)getInstance;

- (void)login;
- (void)signUp;

/**
 *  做任务接口
 */
- (void)doTaskWithTaskId:(NSString *)taskId;

/**
 *  提交审核任务接口
 */
- (void)submitTaskWithTaskId:(NSString *)taskId;

/**
 * 获取验证吗
 */
- (void)getAuthCode;

/**
 * 注册手机号
 */
- (void)signUpPhoneNum:(NSString *)phoneNum osVersion:(NSString*)osver password:(NSString*)pass ip:(NSString*)ip city:(NSString*)city;

/**
 * 修改密码接口
 */
- (void)changeWithOldPass:(NSString*)oldPass newPass:(NSString*)newPass;


@end















