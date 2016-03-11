//
//  HomeModel.h
//  EggsSave
//
//  Created by 郭洪军 on 3/4/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject

@property (copy, nonatomic)NSString* iconName;
@property (copy, nonatomic)NSString* name;
@property (copy, nonatomic)NSString* detail;
@property (copy, nonatomic)NSString* extend;

@end

@interface HomeIncomeModel : NSObject

@property (copy, nonatomic)NSString* myLeftMoney;     //我的余额
@property (copy, nonatomic)NSString* todayStudents;   //今日收徒
@property (copy, nonatomic)NSString* todayIncome;     //今日收入


@end

@interface TiXianMessage : NSObject

@property (copy, nonatomic)NSString* iconName;
@property (copy, nonatomic)NSString* name;
@property (copy, nonatomic)NSString* time;   //提现时间
@property (copy, nonatomic)NSString* detail;

@end



















