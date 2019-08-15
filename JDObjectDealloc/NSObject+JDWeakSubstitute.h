//
//  NSObject+JDWeakSubstitute.h
//  JDTheme
//
//  Created by JD on 2018/8/14.
//  Copyright © 2018年 JD. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JDWeakSubstitute : NSObject

@property (nonatomic, weak) NSObject *SELF;

@end

@interface NSObject (JDWeakSubstitute)

@property (nonatomic, strong, readonly) JDWeakSubstitute *jd_weakSubstitute;

@end



