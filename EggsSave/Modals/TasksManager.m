//
//  TasksManager.m
//  EggsSave
//
//  Created by 郭洪军 on 12/24/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "TasksManager.h"
#import "Task.h"

@interface TasksManager()

@property(strong, nonatomic)NSArray* mTasks;


@end

@implementation TasksManager

+ (id)getInstance
{
    static TasksManager* sharedTasksManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTasksManager = [[self alloc]init];
    });
    
    return sharedTasksManager;
}

- (void)setTasks:(NSArray *)tasks
{
    self.mTasks = tasks;
}

- (NSArray*)getTasks
{
    return _mTasks;
}

- (NSUInteger)getTimeFromDetailString:(NSString*)str
{
    NSString *regex = @"试玩\\d分钟";
    NSError *error;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex
                                                                             options:NSRegularExpressionCaseInsensitive
                                                                               error:&error];
    // 对str字符串进行匹配
    NSArray *matches = [regular matchesInString:str
                                        options:0
                                          range:NSMakeRange(0, str.length)];
  
    NSUInteger shiwantime ;
    if (matches.count > 0) {
        NSTextCheckingResult *match = matches[0];
        NSRange range = [match range];
        NSString *mStr = [str substringWithRange:range];
        
        NSString* st1 = [mStr stringByReplacingOccurrencesOfString:@"试玩" withString:@""];
        NSString* st2 = [st1 stringByReplacingOccurrencesOfString:@"分钟" withString:@""];
        
        if (st2) {
            shiwantime = [st2 integerValue];
        }else
        {
            shiwantime = 0;
        }
    }else
    {
        shiwantime = 5;
    }
    
    return shiwantime ;
}

- (void)parseLoginData:(NSDictionary *)data
{
    NSDictionary* dict = data;
    
    NSDictionary* responseDict = dict[@"response"];
    
    NSArray* putArr = responseDict[@"put"];
        
    NSMutableArray* taskarray = [[NSMutableArray alloc]initWithCapacity:[putArr count]];
    
    for (int i=0; i<[putArr count]; i++) {
        NSDictionary* tempDict = putArr[i];
        
        long      t_id = [tempDict[@"id"] longValue];
        NSString* t_title = tempDict[@"producttitle"];
        NSString* t_subtitle = tempDict[@"definedTitle"];
        NSString* t_starturl = tempDict[@"cpTaskStartUrl"];
        NSString* t_endurl = tempDict[@"cpTaskFineshedUrl"];
        NSString* t_notifyurl = tempDict[@"notifyUrl"];
        NSString* t_iconurl = tempDict[@"icon"];
        NSString* t_detailexplain = tempDict[@"detailTaskExplain"];
        NSString* t_fastplain = tempDict[@"fastTaskExplain"];
        NSString* t_taskkeyword = tempDict[@"keyWord"];
        NSString* t_packageSize = tempDict[@"packagesize"];
        long      t_state = [tempDict[@"state"] longValue];
        float     t_bonus = [tempDict[@"prizeMoney"] floatValue];
        NSArray *t_returnDetailArray = tempDict[@"returnDetailArray"];
        NSUInteger t_taskLimit = [tempDict[@"taskLimit"] integerValue];
        NSUInteger t_shiwantime = [self getTimeFromDetailString:t_detailexplain] ;
        NSString*  t_urlscheme = tempDict[@"isXiaZaiUrl"];
        NSString*  t_processNum = tempDict[@"progressNum"];
        
        Task* t = TaskMake([NSString stringWithFormat:@"%ld",t_id], t_title, t_subtitle, t_starturl, t_endurl, t_notifyurl, t_iconurl, t_detailexplain, t_fastplain, t_taskkeyword, t_packageSize, t_state, t_bonus, t_returnDetailArray, t_taskLimit, t_shiwantime, t_processNum, t_urlscheme);
        
        [taskarray addObject:t];
    }
    
    self.mTasks = taskarray;
    
    DLog(@"self.mTasks = %@", self.mTasks);
    
}

@end
