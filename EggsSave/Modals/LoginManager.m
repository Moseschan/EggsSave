//
//  LoginManager.m
//  EggsSave
//
//  Created by 郭洪军 on 12/24/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "LoginManager.h"
#import "HashUtils.h"
#import "EncryptUtils.h"
#import "TasksManager.h"
#import "CommonDefine.h"
#import "KeychainIDFA.h"
#import "User.h"
#import "DataManager.h"

#import "AFNetWorking.h"

NSString* const NSUserDidLoginedNotification       = @"NSUserDidLoginedNotification" ;
NSString* const NSUserSigninStateNotification      = @"NSUserSigninStateNotification";
NSString* const NSUserSigninNotification           = @"NSUserSigninNotification" ;      //签到
NSString* const NSUserGetMyMoneyNotification       = @"NSUserGetMyMoneyNotification";   //剩余金额
NSString* const NSUserSignUpNotification           = @"NSUserSignUpNotification";
NSString* const NSUserSignUpFailedNotification     = @"NSUserSignUpFailedNotification";
NSString* const NSUserLoginFailedNotification      = @"NSUserLoginFailedNotification";
NSString* const NSUserGetTaskSucceedNotification   = @"NSUserGetTaskSucceedNotification";  //接任务成功
NSString* const NSUserDoTaskCompletedNotification  = @"NSUserDoTaskCompletedNotification";  //审核任务成功与否
NSString* const NSUserGetAuthCodeNotification      = @"NSUserGetAuthCodeNotification" ; //获取验证码
NSString* const NSUserFeedCommitedNotification     = @"NSUserFeedCommitedNotification";  //问题反馈提交成功
NSString* const NSUserGetDetailInfoNotification    = @"NSUserGetDetailInfoNotification"; //获取用户详细信息
NSString* const NSUserTiXianRecordNotification     = @"NSUserTiXianRecordNotification";//提现记录接口
NSString* const NSUserTiXianNotification           = @"NSUserTiXianNotification" ;    //提现接口
NSString* const NSUserTaskRecordNotification       = @"NSUserTaskRecordNotification"; //任务记录
NSString* const NSUserBindPhoneNotification        = @"NSUserBindPhoneNotification";  //绑定手机号
NSString* const NSUserChangePasswordNotification   = @"NSUserChangePasswordNotification"; //修改密码接口
NSString* const NSUserCommitUserDetailNotification = @"NSUserCommitUserDetailNotification"; //提交用户详细信息

@implementation LoginManager

+ (id)getInstance
{
    static LoginManager* sharedloginmanager = nil;
    
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedloginmanager = [[self alloc]init];
    });
    
    return sharedloginmanager;
}

- (NSURLRequest *)requestWithInterface:(NSString *)interface Data:(NSDictionary *)data UncalData:(NSString*)uncalStr
{
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/%@.dsp", DOMAIN_URL,interface];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSString* uncal = uncalStr;
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":data,@"KEY":keyStr};
    
    NSData *data1 = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    
    Byte *dataByte = (Byte *)[data1 bytes];
    
    Byte* encryptByte = [EncryptUtils xorString:dataByte len:(int)[data1 length]];
    Byte* e1 = (Byte*)malloc([data1 length]);
    memset(e1, 0, [data1 length] + 1);
    memcpy(e1, encryptByte, [data1 length]);
    free(encryptByte);
    
    NSData *encryptData = [[NSData alloc] initWithBytes:e1 length:(int)[data1 length]];
    
    request.HTTPBody = encryptData;
    
    free(e1);
    
    return request;
}

- (NSDictionary *)getDataFromEncryptData:(NSData*)data
{
    unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
    NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
    
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
    
    free(decryptByte);
    
    return dict;
}

- (void)login
{
    if (NO_NETWORK) {
        return;
    }
    User* user = [User getInstance];
    NSString* usid = user.userID;
        
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"102" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        
        NSDictionary* dict = [self getDataFromEncryptData:data];
        
        DLog(@"dict = %@", dict);
                
        [[NSNotificationCenter defaultCenter] postNotificationName:NSUserDidLoginedNotification object:nil userInfo:dict];
    }];
}

- (void)signUp
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* userIDFA = [KeychainIDFA IDFA];
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"IDFA",userIDFA];
    
    NSDictionary *t1 = @{@"IDFA":userIDFA} ;
    
    NSURLRequest* request = [self requestWithInterface:@"100" Data:t1 UncalData:uncal];
        
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据,注册失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpFailedNotification object:nil];
            return ;
        }
        
        unsigned char* decryptByte = [EncryptUtils xorString:(unsigned char *)[data bytes] len:(int)[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:decryptByte length:(int)[data length]] options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        
        NSDictionary* responseDict = dict[@"response"];
        long userIDl = [responseDict[@"userId"] longValue];
        NSString* userID = [NSString stringWithFormat:@"%ld",userIDl];
        
        int result = [responseDict[@"result"] intValue];
        if (result == -1) {
            DLog(@"注册失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpFailedNotification object:nil];
        }else if(result == 0)
        {
            [[User getInstance]setUserID:userID];
            [KeychainIDFA setUserID:userID];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpNotification object:nil];
        }else
        {
            DLog(@"注册失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpFailedNotification object:nil];
        }
        
        free(decryptByte);
        
    }];
}

- (void)doTaskWithTaskId:(NSString *)taskId
{
    if (NO_NETWORK) {
        return;
    }
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSString* taid = taskId;
    NSDictionary *t1 = @{@"userId":usid,@"taskId":taid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"taskId",taid,@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"103" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        
        NSDictionary* dict = [self getDataFromEncryptData:data];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserGetTaskSucceedNotification object:nil userInfo:dict];
    }];
}

- (void)getAuthCode
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"106" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        
        NSDictionary *dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserGetAuthCodeNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)signUpPhoneNum:(NSString *)phoneNum osVersion:(NSString*)osver password:(NSString*)pass ip:(NSString*)ip city:(NSString*)city Smscode:(NSString*)smscode
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSString* phone = phoneNum;
    NSDictionary *t1 = @{@"userId":usid,@"phone":phone,@"osVersion":osver,@"password":pass,@"ip":ip,@"cityName":city,@"yanZhengMa":smscode} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"cityName",city,@"ip",ip,@"osVersion",osver,@"password",pass,@"phone",phone,@"userId",usid,@"yanZhengMa",smscode];
    
    NSURLRequest* request = [self requestWithInterface:@"107" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        NSDictionary *dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserBindPhoneNotification object:nil userInfo:responseDict];
        
    }];
     
    
}

- (void)changeWithOldPass:(NSString*)oldPass newPass:(NSString*)newPass
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid,@"newpassword":newPass,@"oldpassword":oldPass} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"newpassword",newPass,@"oldpassword",oldPass,@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"108" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        NSDictionary *dict = [self getDataFromEncryptData:data];
        
        NSDictionary* responseDict = dict[@"response"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserChangePasswordNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)signinQianDao
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"120" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        
        NSDictionary *dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserSigninNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)requestSigninState
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"122" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        
        NSDictionary* dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        
        int status = [responseDict[@"status"] intValue];
        if (status == 0) {
            //是连续签到
        }else if (status == 1)
        {
            //没有连续签到
        }else if (status == 2)
        {
            //今天已经签到过
        }else
        {
            //今天还没有签到
        }
        
        [[DataManager getInstance] setSignStatus:status];
        
        int days = [responseDict[@"hadSignCount"] intValue];
        
        [[DataManager getInstance] setSignDays:days];

        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserSigninStateNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)requestPricessSet
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"119" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        NSDictionary* dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserGetMyMoneyNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)requestTiXianWithAccount:(NSString*)zhiAccount UserName:(NSString*)name Price:(NSString*)price
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid,@"zhiFuBaoZhangHao":zhiAccount,@"zhiFuName":name,@"price":price} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"price",price,@"userId",usid,@"zhiFuBaoZhangHao",zhiAccount,@"zhiFuName",name];
    
    NSURLRequest* request = [self requestWithInterface:@"117" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        NSDictionary* dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserTiXianNotification object:nil userInfo:responseDict];
    }];
}

- (void)requestWithOsVersion:(NSString*)osVersion IpAddress:(NSString*)ip CityName:(NSString*)city NickName:(NSString*)nick Sex:(NSString*)sex BirthDay:(NSString*)birth Work:(NSString*)work
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid,@"osVersion":osVersion,@"ipAddress":ip,@"cityName":city,@"userName":nick,@"sex":sex,@"birthDay":birth,@"career":work} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"birthDay",birth,@"career",work,@"cityName",city,@"ipAddress",ip,@"osVersion",osVersion,@"sex",sex,@"userId",usid,@"userName",nick];
    
    NSURLRequest* request = [self requestWithInterface:@"123" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        NSDictionary *dict = [self getDataFromEncryptData:data];
        DLog(@"dict = %@",dict);
        NSDictionary* responseDict = dict[@"response"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserCommitUserDetailNotification object:responseDict];
    }];
}

- (void)requestUserDetailMessages
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"118" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        
        User* u = [User getInstance];
        NSDictionary *dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        u.todayPrice = [responseDict[@"todayPrice"] floatValue];
        NSDictionary* userInfo = responseDict[@"userInfo"];
        u.userIDFA      = userInfo[@"idfa"];
        u.birthDay      = userInfo[@"birthDay"];
        u.carrier       = userInfo[@"carrier"];
        u.money         = [userInfo[@"price"] floatValue];
        u.sex           = userInfo[@"sex"];
        u.studentsPrice = [userInfo[@"studentPrice"] floatValue];
        u.nickName      = userInfo[@"userName"];
        u.phoneNum      = userInfo[@"mobile"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSUserGetDetailInfoNotification object:nil];
        
    }];
}

- (void)requestCommitQuestions:(NSString*)questions
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid,@"feedBackQuestion":questions} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"feedBackQuestion",questions,@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"126" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        NSDictionary* dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserFeedCommitedNotification object:responseDict];
    }];
}

- (void)requestTixianRecord
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"127" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        
        NSDictionary *dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        DLog(@"tixianRecord Dict = %@", dict);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSUserTiXianRecordNotification object:nil userInfo:responseDict];
    }];
}

- (void)requestTaskRecord
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"130" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        
        NSDictionary *dict = [self getDataFromEncryptData:data];
        NSDictionary* responseDict = dict[@"response"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSUserTaskRecordNotification object:nil userInfo:responseDict];
    }];
}

- (void)requestTaskFinishedWithTaskID:(NSString*)taskid
{
    if (NO_NETWORK) {
        return;
    }
    
    User* user = [User getInstance];
    NSString* usid = user.userID;
    NSDictionary *t1 = @{@"userId":usid,@"taskId":taskid,@"successState":@"0"} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"successState",@"0",@"taskId",taskid,@"userId",usid];
    
    NSURLRequest* request = [self requestWithInterface:@"128" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
        NSDictionary* dict = [self getDataFromEncryptData:data];
        
        NSDictionary* responseDict = dict[@"response"];
        
//        NSString* message = responseDict[@"message"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserDoTaskCompletedNotification object:responseDict];
    }];
}

- (void)requestSmsAuthCodeWithPhoneNum:(NSString*)phoneNum IpAddress:(NSString*)ip
{
    if (NO_NETWORK) {
        return;
    }
    
    NSDictionary *t1 = @{@"phone":phoneNum,@"ip":ip} ;
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"ip",ip,@"phone",phoneNum];
    
    NSURLRequest* request = [self requestWithInterface:@"131" Data:t1 UncalData:uncal];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        if (!data) {
            DLog(@"未获取到数据");
            return ;
        }
//        NSDictionary* dict = [self getDataFromEncryptData:data];
//        NSDictionary* responseDict = dict[@"response"];
//        
//        NSLog(@"smsauthcode dict = %@", dict);
        
//        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserFeedCommitedNotification object:responseDict];
    }];
}

@end
