//
//  FTDHeadModel.h
//  EggsSave
//
//  Created by 郭洪军 on 3/3/16.
//  Copyright © 2016 Adwan. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface FTDHeadModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *bodySize;
@property (nonatomic, copy) NSString *iconImageName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *fastExplain;

@end


@interface FTDIntroModel : NSObject

@property (nonatomic, strong) NSArray *details;

@end
