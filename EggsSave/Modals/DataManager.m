//
//  DataManager.m
//  EggsSave
//
//  Created by 郭洪军 on 3/8/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()
{
    int     _signStatus;
    int     _signDays;
    float   _myMoney;
}

@end

@implementation DataManager

+ (id)getInstance
{
    static DataManager* sharedDataManager = nil;
    
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedDataManager = [[self alloc]init];
    });
    
    return sharedDataManager;
}

- (void)setSignStatus:(int)status
{
    _signStatus = status;
}

- (int)getSignStatus
{
    return _signStatus;
}

- (void)setSignDays:(int)days
{
    _signDays = days;
}

- (int)getSignDays
{
    return _signDays;
}

- (void)setMyMoney:(float)money
{
    _myMoney = money;
}

- (float)getMyMoney
{
    return _myMoney;
}

@end

















