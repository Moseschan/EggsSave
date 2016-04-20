//
//  AudioManager.h
//  IOKitBrowser
//
//  Created by 郭洪军 on 4/5/16.
//  Copyright © 2016 Electric Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioManager : NSObject

+ (AudioManager*) getInstance;

- (void)play;

@end
