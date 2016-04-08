//
//  TimeHeart.h
//  EggsSave
//
//  Created by 郭洪军 on 4/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeHeart : NSObject

+ (TimeHeart *) getInstance;

@property(assign, nonatomic)NSUInteger  time;
@property(assign, nonatomic)NSUInteger  lastTime;

@property(assign, nonatomic)BOOL        isRunning;

@property(assign, nonatomic)BOOL        isDownloading; //判断试玩应用是否已下载任务是否开始
@property(assign, nonatomic)NSUInteger  swTime;        //试玩了多长时间 shiwanTime

@end
