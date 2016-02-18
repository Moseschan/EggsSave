//
//  User.m
//  EggsSave
//
//  Created by 郭洪军 on 12/23/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "User.h"

@implementation User

+ (id)getInstance
{
    static User* sharedUser = nil;
    
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedUser = [[User alloc]init];
    });
    
    return sharedUser;
}

@end
