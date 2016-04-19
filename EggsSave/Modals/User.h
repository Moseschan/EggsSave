//
//  User.h
//  EggsSave
//
//  Created by 郭洪军 on 12/23/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(copy, nonatomic)NSString*   userID;
@property(copy, nonatomic)NSString*   userIDFA;
@property(assign, nonatomic)int       todayPrice;   //今日收入   （单位：分）
@property(copy, nonatomic)NSString*   birthDay;     //生日
@property(copy, nonatomic)NSString*   carrier;      //职业
@property(assign, nonatomic)int       money;        //余额       （单位：分）
@property(copy, nonatomic)NSString*   sex;          //性别
@property(copy, nonatomic)NSString*   nickName;     //昵称
@property(assign, nonatomic)float     studentsPrice;//徒弟收入
@property(copy, nonatomic)NSString*   phoneNum;     //手机号


+ (id)getInstance;


@end
