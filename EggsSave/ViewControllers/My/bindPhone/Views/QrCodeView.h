//
//  QrCodeView.h
//  EggsSave
//
//  Created by 郭洪军 on 1/5/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QrCodeView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;
- (IBAction)cancelAction:(id)sender;

@end
