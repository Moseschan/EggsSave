//
//  QrCodeView.m
//  EggsSave
//
//  Created by 郭洪军 on 1/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import "QrCodeView.h"
#import "QRCodeGenerator.h"

@implementation QrCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"QrCodeView" owner:self options:nil] lastObject];
    }
    
    if (frame.size.width != 0) {
        self.frame = frame;
    }
    
    self.qrcodeImageView.image = [QRCodeGenerator qrImageForString:@"郭洪军" imageSize:_qrcodeImageView.bounds.size.width];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)cancelAction:(id)sender {
    
    [self removeFromSuperview];
}
@end
