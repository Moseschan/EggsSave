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

@end
