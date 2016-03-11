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

- (void)login
{
    if (NO_NETWORK) {
        return;
    }
    
//    NSString* usid = [KeychainIDFA getUserId];
    NSString* usid = @"290";
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/102.dsp", DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        [[TasksManager getInstance]parseLoginData:dataData];
        free(decryptByte);
        
        DLog(@"登录成功");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSUserDidLoginedNotification object:nil];
        
        //在这里还要监测登陆成功或失败
                
    }];
    
    
//    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/json",@"application/json",@"text/javascript",@"text/html",nil];
//    
//    NSString* usid = @"290";
//    
//    // 1.创建请求
//    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/102.dsp", DOMAIN_URL];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    request.HTTPMethod = @"POST";
//    
//    // 2.设置请求头
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    NSDictionary *t1 = @{@"userId":usid} ;
//    
//    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
//    const char *cuncal =[uncal UTF8String];
//    
//    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
//    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
//    
//    // 3.设置请求体
//    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
//    
//    NSData *data1 = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
//    
//    Byte *dataByte = (Byte *)[data1 bytes];
//    
//    Byte* encryptByte = [EncryptUtils xorString:dataByte len:(int)[data1 length]];
//    Byte* e1 = (Byte*)malloc([data1 length]);
//    memset(e1, 0, [data1 length] + 1);
//    memcpy(e1, encryptByte, [data1 length]);
//    free(encryptByte);
//    
//    NSData *encryptData = [[NSData alloc] initWithBytes:e1 length:(int)[data1 length]];
//    
//    request.HTTPBody = encryptData;
//    
//    free(e1);
//    
//    // 4.发送请求
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
//        
//        if (!data) {
//            
//            DLog(@"未获取到数据");
//            
//            return ;
//        }
//        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
//        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
//        
//        [[TasksManager getInstance]parseLoginData:dataData];
//        free(decryptByte);
//        
//        DLog(@"登录成功");
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:NSUserDidLoginedNotification object:nil];
//        
//        //在这里还要监测登陆成功或失败
//        
//    }];
//    
//    
//    
//    
//    
//    //传入的参数
//    NSDictionary *parameters = @{@"requestKey":@"rightOnePage"};
//    //你的接口地址
//    NSString *url=urlString;
//    //发送请求
//    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        ZhuBoPage* zhubo = [[ZhuBoPage alloc]init];
//        zhubo.allVirtualUsers = [[NSMutableArray alloc]init];
//        zhubo.allPics = [[NSMutableArray alloc]init];
//        
//        NSDictionary* mainDic = responseObject;
//        NSArray* pictures = mainDic[@"pictures"];
//        
//        for (int i=0; i<pictures.count; ++i) {
//            NSDictionary* tDic = pictures[i];
//            
//            hpProp* hpr = [[hpProp alloc]init];
//            hpr.name = tDic[@"name"];
//            hpr.picUrl = tDic[@"requestUrl"];
//            
//            [zhubo.allPics addObject:hpr];
//        }
//        
//        DataManager* dataManager = [DataManager sharedManager];
//        dataManager.zhuboPage = zhubo;
//        
//        block(YES);
//        
//        //        NSLog(@"JSON: %@", mainDic);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        block(NO);
//    }];
    
}

- (void)signUp
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* userIDFA = [KeychainIDFA IDFA];
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"IDFA",userIDFA];
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/100.dsp", DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"IDFA":userIDFA} ;
    
    const char *cuncal =[uncal UTF8String];
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
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
        
    // 4.发送请求
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
    
    NSString* usid = [KeychainIDFA getUserId];
    NSString* taid = taskId;
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/103.dsp", DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid,@"taskId":taid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"taskId",taid,@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
    DLog(@"json = %@",json);
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        NSDictionary* responseDict = dict[@"response"];
        
        int result = [responseDict[@"result"] intValue];
        NSString* message = responseDict[@"message"];
        
        if (result == 0) {
            DLog(@"接受任务成功");
            [[NSNotificationCenter defaultCenter]postNotificationName:NSUserGetTaskSucceedNotification object:nil];
        }else
        {
            DLog(@"接受任务失败，失败原因 : %@", message);
        }
        
        free(decryptByte);
        
        
    }];
}

- (void)submitTaskWithTaskId:(NSString *)taskId
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* usid = [KeychainIDFA getUserId];
    NSString* taid = taskId;
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/104.dsp" , DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid,@"taskId":taid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"taskId",taid,@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
    DLog(@"json = %@",json);
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        NSDictionary* responseDict = dict[@"response"];
        
        int result = [responseDict[@"result"] intValue];
        
        if (result == -1) {
            DLog(@"审核任务失败");
            [[NSNotificationCenter defaultCenter]postNotificationName:NSUserDoTaskFailedNotification object:nil];
        }else
        {
            DLog(@"做任务失败");
        }
        
        free(decryptByte);
        
        
    }];
}

- (void)getAuthCode
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* usid = [KeychainIDFA getUserId];
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/106.dsp" , DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        NSDictionary* responseDict = dict[@"response"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserGetAuthCodeNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)signUpPhoneNum:(NSString *)phoneNum osVersion:(NSString*)osver password:(NSString*)pass ip:(NSString*)ip city:(NSString*)city
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* usid = [KeychainIDFA getUserId];
    NSString* phone = phoneNum;
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/107.dsp", DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid,@"phone":phone,@"osVersion":osver,@"password":pass,@"ip":ip,@"cityName":city} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"cityName",city,@"ip",ip,@"osVersion",osver,@"password",pass,@"phone",phone,@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
    DLog(@"json = %@",json);
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        
        free(decryptByte);
        
        
    }];
     
    
}

- (void)changeWithOldPass:(NSString*)oldPass newPass:(NSString*)newPass
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* usid = [KeychainIDFA getUserId];
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/108.dsp", DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";

    NSDictionary *t1 = @{@"userId":usid,@"newpassword":newPass,@"oldpassword":oldPass} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"newpassword",newPass,@"oldpassword",oldPass,@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
    DLog(@"json = %@", json);
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        
        DLog(@"data = %@", data);
        
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        
        free(decryptByte);
        
    }];
}

- (void)signinQianDao
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* usid = [KeychainIDFA getUserId];
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/120.dsp" , DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        NSDictionary* responseDict = dict[@"response"];
//
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserSigninNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)requestSigninState
{
    if (NO_NETWORK) {
        return;
    }
    
    NSString* usid = [KeychainIDFA getUserId];
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/122.dsp" , DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
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
    
//    NSString* usid = [KeychainIDFA getUserId];
    NSString* usid = @"290";
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/119.dsp" , DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"userId",usid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        NSDictionary* responseDict = dict[@"response"];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:NSUserGetMyMoneyNotification object:nil userInfo:responseDict];
        
    }];
}

- (void)requestTiXianWithAccount:(NSString*)zhiAccount UserName:(NSString*)name Price:(NSString*)price
{
    if (NO_NETWORK) {
        return;
    }
    
//    NSString* usid = [KeychainIDFA getUserId];
    NSString* usid = @"290";
    
    // 1.创建请求
    NSString* urlString = [NSString stringWithFormat:@"http://%@/newwangluo/app/117.dsp", DOMAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSDictionary *t1 = @{@"userId":usid,@"zhiFuBaoZhangHao":zhiAccount,@"zhiFuName":name,@"price":price} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\",\"%@\":\"%@\"}",@"price",price,@"userId",usid,@"zhiFuBaoZhangHao",zhiAccount,@"zhiFuName",name];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
    DLog(@"json = %@", json);
    
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
    
    // 4.发送请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response,NSData *data, NSError *connectionError) {
        
        if (!data) {
            
            DLog(@"未获取到数据");
            
            return ;
        }
        
        DLog(@"data = %@", data);
        
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        DLog(@"dict = %@",dict);
        
        free(decryptByte);
        
    }];
}

@end
