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

@end
