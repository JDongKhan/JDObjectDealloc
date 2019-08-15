//
//  Manager.h
//  Demo
//
//  Created by JD on 2019/8/14.
//  Copyright © 2019 JD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Manager : NSObject

+ (instancetype)sharedInstance;

- (void)addObject:(id)object;

- (void)removeObject:(id)object;

@end

NS_ASSUME_NONNULL_END
