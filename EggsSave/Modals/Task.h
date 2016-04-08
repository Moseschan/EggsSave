//
//  Task.h
//  EggsSave
//
//  Created by 郭洪军 on 12/24/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property(copy, nonatomic)NSString*     pId;                        //任务Id
@property(copy, nonatomic)NSString*     pTitle;                     //产品标题
@property(assign, nonatomic)float       pBonus;                     //奖励金额
@property(copy, nonatomic)NSString*     pSubTitle;                  //子标题
@property(copy, nonatomic)NSString*     pStartURL;                  //cp任务开始URL
@property(copy, nonatomic)NSString*     pEndURL;                    //cp任务完成URL
@property(copy, nonatomic)NSString*     pNotifyURL;                 //平台任务达成回调URL
@property(copy, nonatomic)NSString*     pIconUrl;                   //icon地址
@property(copy, nonatomic)NSString*     pDetailTaskExplain;         //详细任务说明
@property(copy, nonatomic)NSString*     pFastTaskExplain;           //快速任务说明
@property(copy, nonatomic)NSString*     pKeyWord;                   //关键字
@property(copy, nonatomic)NSString*     pPackagesize;               //包体大小
@property(assign, nonatomic)long        pState;                     //任务领取的状态 0,领取，未完成 1，完成 2，未领取
@property(strong, nonatomic)NSArray*    returnDetailArray;          //详细任务说明
@property(assign, nonatomic)NSUInteger  pTaskLimit;                 //任务时限
@property(assign, nonatomic)NSUInteger  pShiwanTime;                //试玩时间
@property(copy, nonatomic)NSString*     pProcessNum;                //进程号
@property(copy, nonatomic)NSString*     pUrlScheme;                 //应用的url


@end


static inline Task* TaskMake(NSString*tid, NSString* title, NSString* subTitle, NSString* startURL, NSString* endURL, NSString* notifyURL, NSString* iconURL, NSString* detailTaskExplain, NSString* fastTaskExplain, NSString* keyWord, NSString* packageSize, long state, float bonus, NSArray *returnDetailArray, NSUInteger limitTime, NSUInteger shiwanTime, NSString* processNum, NSString* urlScheme)
{
    Task* task = [[Task alloc] init];
    task.pId = tid;
    task.pTitle = title;
    task.pSubTitle = subTitle;
    task.pStartURL = startURL;
    task.pEndURL = endURL;
    task.pNotifyURL = notifyURL;
    task.pIconUrl = iconURL;
    task.pDetailTaskExplain = detailTaskExplain;
    task.pFastTaskExplain = fastTaskExplain;
    task.pKeyWord = keyWord;
    task.pPackagesize = packageSize;
    task.pState = state;
    task.pBonus = bonus;
    task.returnDetailArray = returnDetailArray;
    task.pTaskLimit = limitTime;
    task.pShiwanTime = shiwanTime;
    task.pProcessNum = processNum;
    task.pUrlScheme = urlScheme;
    return task;
}

