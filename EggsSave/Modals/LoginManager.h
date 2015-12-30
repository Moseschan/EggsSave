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


@end
