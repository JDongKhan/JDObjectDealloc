//
//  NSObject+JDWeakSubstitute.m
//  JDTheme
//
//  Created by JD on 2018/8/14.
//  Copyright © 2018年 JD. All rights reserved.
//

#import "NSObject+JDWeakSubstitute.h"
#import <objc/runtime.h>


@implementation NSObject (JDWeakSubstitute)

- (JDWeakSubstitute *)jd_weakSubstitute {
    JDWeakSubstitute *weakSubstitute = objc_getAssociatedObject(self,_cmd);
    if (!weakSubstitute) {
        weakSubstitute = [[JDWeakSubstitute alloc] init];
        weakSubstitute.SELF = self;
        objc_setAssociatedObject(self, _cmd, weakSubstitute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return weakSubstitute;
}

@end

@implementation JDWeakSubstitute

@end
