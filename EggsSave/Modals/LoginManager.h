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

/**
 *  登录接口
 */
- (void)login;

/**
 *  注册接口
 */
- (void)signUp;

/**
 *  做任务接口
 */
- (void)doTaskWithTaskId:(NSString *)taskId;

/**
 *  获取验证吗
 */
- (void)getAuthCode;

/**
 *  注册手机号
 */
- (void)signUpPhoneNum:(NSString *)phoneNum osVersion:(NSString*)osver password:(NSString*)pass ip:(NSString*)ip city:(NSString*)city Smscode:(NSString*)smscode;

/**
 *  修改密码接口
 */
- (void)changeWithOldPass:(NSString*)oldPass newPass:(NSString*)newPass;

/**
 *  签到接口
 */
- (void)signinQianDao;

/**
 *  请求签到状态接口
 */
- (void)requestSigninState;

/**
 *  获取当前用户余额，以及限制价格集合
 */
- (void)requestPricessSet;

/**
 * 请求减去用户提现金额
 */
- (void)requestTiXianWithAccount:(NSString*)zhiAccount UserName:(NSString*)name Price:(NSString*)price;

/**
 *  用户详细信息
 */
- (void)requestWithOsVersion:(NSString*)osVersion IpAddress:(NSString*)ip CityName:(NSString*)city NickName:(NSString*)nick Sex:(NSString*)sex BirthDay:(NSString*)birth Work:(NSString*)work;

/**
 *  获取用户详细信息
 */
- (void)requestUserDetailMessages;

/**
 *  用户反馈接口
 */
- (void)requestCommitQuestions:(NSString*)questions;

/**
 *  提现记录接口
 */
- (void)requestTixianRecord;

/**
 *  任务记录接口
 */
- (void)requestTaskRecord;

/**
 *  向服务器请求任务已经完成
 */
- (void)requestTaskFinishedWithTaskID:(NSString*)taskid;

/**
 *  获取短信验证码接口
 */
- (void)requestSmsAuthCodeWithPhoneNum:(NSString*)phoneNum IpAddress:(NSString*)ip;

@end
















