//
//  ProcessManager.m
//  EggsSave
//
//  Created by 郭洪军 on 4/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "ProcessManager.h"
#import "ELLIOKitNodeInfo.h"
#import "ELLIOKitDumper.h"
#include <objc/runtime.h>

@interface ProcessManager ()

@property(nonatomic, strong) ELLIOKitNodeInfo *root;
@property(nonatomic, strong) ELLIOKitNodeInfo *locationInTree;
@property(nonatomic, strong) ELLIOKitDumper *dumper;

@property(nonatomic, strong) NSMutableArray* processes;  //存放所有的进程名称

@end

@implementation ProcessManager

+ (ProcessManager *)getInstance
{
    static ProcessManager* sharedmanager = nil;
    
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        sharedmanager = [[self alloc]init];
        sharedmanager.dumper = [ELLIOKitDumper new];
        sharedmanager.processes = [[NSMutableArray alloc]init];
    });
    
    return sharedmanager;
}

- (void)loadIOKit {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.root = [_dumper dumpIOKitTree];
        self.locationInTree = _root;
        
        ELLIOKitNodeInfo* info = self.locationInTree.children[0];
        self.locationInTree = info ;
        
        ELLIOKitNodeInfo* info1 = self.locationInTree.children[1];
        self.locationInTree = info1;
        
        ELLIOKitNodeInfo* info2 = self.locationInTree.children[18];
        self.locationInTree = info2;
        
        if (self.processes.count != 0) {
            [_processes removeAllObjects];
        }
        
        for (NSUInteger i = 0; i<info2.children.count; ++i) {
            
            ELLIOKitNodeInfo* inf = self.locationInTree.children[i];
            
            NSArray* props = inf.properties;
            
            NSString* prop = props[0];
            
            NSArray *array = [prop componentsSeparatedByString:@","];
            
            NSString* string1 = array[1];
            
            NSString *str = [string1 stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            [_processes addObject:str];
        }
    });
}

- (BOOL)processIsRunning:(NSString *)name
{
    BOOL bRet = NO;
    
    for (NSUInteger i = 0; i<_processes.count; ++i) {
        NSString* pStr = _processes[i];
        
        if ([pStr isEqual:name]) {
            return YES;
        }
    }
    
    return bRet;
}

- (NSArray *)getAllAppsInstalled
{
    Class LSApplicationWorkspace_class = objc_getClass("LSApplicationWorkspace");
    NSObject* workspace = [LSApplicationWorkspace_class performSelector:@selector(defaultWorkspace)];
    NSArray* arr = [workspace performSelector:@selector(allApplications)] ;
    
    NSMutableArray* apps = [[NSMutableArray alloc]initWithCapacity:arr.count];
    for (NSUInteger i=0; i<arr.count; ++i) {
        NSObject *app = arr[i];
        NSString *identifier = [app performSelector:@selector(applicationIdentifier)];
        
        [apps addObject:identifier];
    }
    
    return apps;
}

- (void)applicationIdentifier
{
}

- (void)defaultWorkspace
{
}

- (void)allApplications
{
}

@end
