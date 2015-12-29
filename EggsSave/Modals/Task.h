//
//  Task.h
//  EggsSave
//
//  Created by 郭洪军 on 12/24/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property(strong, nonatomic)NSString* pId;                  //任务Id
@property(strong, nonatomic)NSString* pTitle;               //产品标题
@property(assign, nonatomic)float pBonus;                   //奖励金额
@property(strong, nonatomic)NSString* pSubTitle;            //子标题
@property(strong, nonatomic)NSString* pStartURL;            //cp任务开始URL
@property(strong, nonatomic)NSString* pEndURL;              //cp任务完成URL
@property(strong, nonatomic)NSString* pNotifyURL;           //平台任务达成回调URL
@property(strong, nonatomic)NSString* pIconUrl;             //icon地址
@property(strong, nonatomic)NSString* pDetailTaskExplain;   //详细任务说明
@property(strong, nonatomic)NSString* pFastTaskExplain;     //快速任务说明


@end


static inline Task* TaskMake(NSString* title, NSString* subTitle, NSString* startURL, NSString* endURL, NSString* notifyURL, NSString* iconURL, NSString* detailTaskExplain, NSString* fastTaskExplain, float bonus)
{
    Task* task = [[Task alloc] init];
    task.pTitle = title;
    task.pSubTitle = subTitle;
    task.pStartURL = startURL;
    task.pEndURL = endURL;
    task.pNotifyURL = notifyURL;
    task.pIconUrl = iconURL;
    task.pDetailTaskExplain = detailTaskExplain;
    task.pFastTaskExplain = fastTaskExplain;
    task.pBonus = bonus;
    return task;
}