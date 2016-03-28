
#import <Foundation/Foundation.h>

@interface QuestionGroup : NSObject

@property (nonatomic,copy) NSString *groupName;
@property (nonatomic,strong) NSMutableArray *answersArray;
@property (nonatomic,assign) BOOL isOpen;  //是否是打开状态

@end
