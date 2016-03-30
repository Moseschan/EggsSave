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


@interface MyTableViewHeaderModel : NSObject

@property(copy, nonatomic)NSString* userID;
@property(copy, nonatomic)NSString* userNick;
@property(copy, nonatomic)NSString* userMoney;

@end


@interface MyTableViewHeader : UIView

@property (nonatomic, copy)MyTableHeaderSetMessage mthSetMessage;
@property (nonatomic, copy)MyTableHeaderShowAvatar mthShowAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (strong, nonatomic)MyTableViewHeaderModel* model;

- (IBAction)showMyMessages:(id)sender;
- (IBAction)setMyMessage:(id)sender;

- (void)showAvatar;

@end
