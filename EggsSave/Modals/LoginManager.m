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
    NSString* usid = [KeychainIDFA getUserId];
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://123.57.85.254:8080/newwangluo/app/102.dsp"];
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
            
            NSLog(@"未获取到数据");
            
            return ;
        }
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        [[TasksManager getInstance]parseLoginData:dataData];
        free(decryptByte);
        
        NSLog(@"登录成功");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NSUserDidLoginedNotification object:nil];
        
        //在这里还要监测登陆成功或失败
                
    }];
}

- (void)signUp
{
    NSString* userIDFA = [KeychainIDFA IDFA];
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\"}",@"IDFA",userIDFA];
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://123.57.85.254:8080/newwangluo/app/100.dsp"];
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
            NSLog(@"未获取到数据,注册失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpFailedNotification object:nil];
            return ;
        }
        
        unsigned char* decryptByte = [EncryptUtils xorString:(unsigned char *)[data bytes] len:(int)[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:decryptByte length:(int)[data length]] options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dict = %@",dict);
        
        NSDictionary* responseDict = dict[@"response"];
        long userIDl = [responseDict[@"userId"] longValue];
        NSString* userID = [NSString stringWithFormat:@"%ld",userIDl];
        
        int result = [responseDict[@"result"] intValue];
        if (result == -1) {
            NSLog(@"注册失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpFailedNotification object:nil];
        }else if(result == 0)
        {
            [[User getInstance]setUserID:userID];
            [KeychainIDFA setUserID:userID];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpNotification object:nil];
        }else
        {
            NSLog(@"注册失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:NSUserSignUpFailedNotification object:nil];
        }
        
        free(decryptByte);
        
    }];
}

- (void)doTaskWithTaskId:(NSString *)taskId
{
    NSString* usid = [KeychainIDFA getUserId];
    NSString* taid = taskId;
    
    // 1.创建请求
    NSURL *url = [NSURL URLWithString:@"http://123.57.85.254:8080/newwangluo/app/103.dsp"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *t1 = @{@"userId":usid,@"taskId":taid} ;
    
    NSString* uncal = [NSString stringWithFormat:@"{\"%@\":\"%@\",\"%@\":\"%@\"}",@"userId",usid,@"taskId",taid];
    const char *cuncal =[uncal UTF8String];
    
    int caledKey = [HashUtils calculateHashKey:(unsigned char*)cuncal];
    NSString* keyStr = [NSString stringWithFormat:@"%d",caledKey];
    
    // 3.设置请求体
    NSDictionary *json = @{@"data":t1,@"KEY":keyStr};
    
    NSLog(@"json = %@",json);
    
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
            
            NSLog(@"未获取到数据");
            
            return ;
        }
        unsigned char* decryptByte = [EncryptUtils xorString:(Byte *)[data bytes] len:(int)[data length]];
        NSData* dataData = [[NSData alloc]initWithBytes:decryptByte length:[data length]];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataData options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dict = %@",dict);
        
        free(decryptByte);
        
        NSLog(@"接受任务成功");
        
        
        //在这里还要监测登陆成功或失败
        
    }];
}

@end
