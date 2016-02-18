//
//  MyTableViewHeader.m
//  EggsSave
//
//  Created by 郭洪军 on 12/31/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "MyTableViewHeader.h"

@implementation MyTableViewHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"MyTableViewHeader" owner:self options:nil] lastObject];
    }
    
    if (frame.size.width != 0) {
        self.frame = frame;
    }
   
    return self;
}

- (IBAction)showMyMessages:(id)sender {
    if (self.mthSetMessage) {
        self.mthSetMessage();
    }
}

- (IBAction)setMyMessage:(id)sender {
    if (self.mthSetMessage) {
        self.mthSetMessage();
    }
}

- (void)showAvatar
{
    if (self.mthShowAvatar) {
        self.mthShowAvatar();
    }
}











@end
