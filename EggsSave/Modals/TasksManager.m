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

- (void)parseLoginData:(NSData *)data
{
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    NSLog(@"jsonData = %@", dict);
    
    NSDictionary* responseDict = dict[@"response"];
    
    NSArray* putArr = responseDict[@"put"];
        
    NSMutableArray* taskarray = [[NSMutableArray alloc]initWithCapacity:[putArr count]];
    
    for (int i=0; i<[putArr count]; i++) {
        NSDictionary* tempDict = putArr[i];
        
        NSString* t_title = tempDict[@"producttitle"];
        NSString* t_subtitle = tempDict[@"definedTitle"];
        NSString* t_starturl = tempDict[@"cpTaskStartUrl"];
        NSString* t_endurl = tempDict[@"cpTaskFineshedUrl"];
        NSString* t_notifyurl = tempDict[@"notifyUrl"];
        NSString* t_iconurl = tempDict[@"icon"];
        NSString* t_detailexplain = tempDict[@"detailTaskExplain"];
        NSString* t_fastplain = tempDict[@"fastTaskExplain"];
        float     t_bonus = [tempDict[@"prizeMoney"] floatValue];
        
        Task* t = TaskMake(t_title, t_subtitle, t_starturl, t_endurl, t_notifyurl, t_iconurl, t_detailexplain, t_fastplain, t_bonus);
        
        NSLog(@"t.title = %@, t.detail = %@", t.pTitle, t.pDetailTaskExplain);
        
        [taskarray addObject:t];
    }
    
    self.mTasks = taskarray;
    
    NSLog(@"self.mTasks = %@", self.mTasks);
    
}

@end
