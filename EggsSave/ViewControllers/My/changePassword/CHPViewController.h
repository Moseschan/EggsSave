//
//  CHPViewController.h
//  EggsSave
//
//  Created by 郭洪军 on 1/7/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHPViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPassTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstPassTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassTextField;

- (IBAction)changePassword:(id)sender;

@end
