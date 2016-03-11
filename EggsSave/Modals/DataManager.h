//
//  DataManager.h
//  EggsSave
//
//  Created by 郭洪军 on 3/8/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (id)getInstance;

//签到状态  是否签到
- (void)setSignStatus:(int)status;
- (int)getSignStatus;

//已签到天数
- (void)setSignDays:(int)days;
- (int)getSignDays;

//提现接口
- (void)setMyMoney:(float)money;
- (float)getMyMoney;

@end
