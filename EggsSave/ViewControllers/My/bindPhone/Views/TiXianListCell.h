//
//  TiXianListCell.h
//  EggsSave
//
//  Created by 郭洪军 on 3/21/16.
//  Copyright © 2016 Adwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TiXianListCellModel : NSObject

@property (copy, nonatomic)NSString* tiAccount;
@property (copy, nonatomic)NSString* tiPrice;
@property (copy, nonatomic)NSString* tiTime;
@property (copy, nonatomic)NSString* tiState;

@end

@interface TiXianListCell : UITableViewCell

@property (strong, nonatomic)TiXianListCellModel* model;

@end
