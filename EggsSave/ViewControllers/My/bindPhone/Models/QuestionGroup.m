
#import "QuestionGroup.h"

@implementation QuestionGroup

-(NSMutableArray *)answersArray
{
    if (!_answersArray) {
        _answersArray = [NSMutableArray array];
    }
    return _answersArray;
}

@end
