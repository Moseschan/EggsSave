//
//  User.h
//  EggsSave
//
//  Created by 郭洪军 on 12/23/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(strong, nonatomic)NSString* userID;
@property(strong, nonatomic)NSString* userIDFA;


+ (id)getInstance;


@end
