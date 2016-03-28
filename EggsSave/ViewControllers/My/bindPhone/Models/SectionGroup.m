
#import "SectionGroup.h"

@implementation SectionGroup

- (NSMutableArray *)questionGroupArray
{
    if (_questionGroupArray) {
        _questionGroupArray = [NSMutableArray array];
    }
    
    return _questionGroupArray;
}

@end
