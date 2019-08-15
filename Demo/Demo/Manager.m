//
//  Manager.m
//  Demo
//
//  Created by JD on 2019/8/14.
//  Copyright © 2019 JD. All rights reserved.
//

#import "Manager.h"
#import "JDMutableWeakArray.h"

@implementation Manager {
    JDMutableWeakArray *_weakArray;
}


+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static Manager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[Manager alloc] init];
        instance->_weakArray = [[JDMutableWeakArray alloc] init];
    });
    return instance;
}

- (void)addObject:(id)object {
    [_weakArray addObject:object];
}

- (void)removeObject:(id)object {
    [_weakArray removeObject:object];
}

@end
