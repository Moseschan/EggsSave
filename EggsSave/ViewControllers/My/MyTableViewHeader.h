//
//  MyTableViewHeader.h
//  EggsSave
//
//  Created by 郭洪军 on 12/31/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * Block delegates
 */
typedef void(^MyTableHeaderSetMessage)(void);
typedef void (^MyTableHeaderShowAvatar)(void);

@interface MyTableViewHeader : UIView

@property (nonatomic, copy)MyTableHeaderSetMessage mthSetMessage;
@property (nonatomic, copy)MyTableHeaderShowAvatar mthShowAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

- (IBAction)showMyMessages:(id)sender;
- (IBAction)setMyMessage:(id)sender;

- (void)showAvatar;

@end
