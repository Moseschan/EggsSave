//
//  ProcessManager.h
//  EggsSave
//
//  Created by 郭洪军 on 4/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcessManager : NSObject

+ (ProcessManager *)getInstance;

- (void)loadIOKit ;

- (BOOL)processIsRunning:(NSString *)name;

/**
 *  获取所有已安装应用的bundle id
 **/
- (NSArray *)getAllAppsInstalled;

@end
