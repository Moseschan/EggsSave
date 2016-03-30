//
//  MyTableViewHeader.m
//  EggsSave
//
//  Created by 郭洪军 on 12/31/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "MyTableViewHeader.h"

@implementation MyTableViewHeaderModel


@end

@interface MyTableViewHeader ()

@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;


@end

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

- (void)setModel:(MyTableViewHeaderModel *)model
{
    _model = model;
    
    if (_model.userID) {
        _idLabel.text = [NSString stringWithFormat:@"ID %@", _model.userID];
    }
    
    if (_model.userMoney) {
        _moneyLabel.text = [NSString stringWithFormat:@"%@元", _model.userMoney];
    }
    
    if (_model.userNick) {
        _nickLabel.text = _model.userNick;
    }
    
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
