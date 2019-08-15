#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JDMutableWeakArray.h"
#import "JDMutableWeakDictionary.h"
#import "NSObject+JDDeallocBlock.h"
#import "NSObject+JDWeakSubstitute.h"

FOUNDATION_EXPORT double JDObjectDeallocVersionNumber;
FOUNDATION_EXPORT const unsigned char JDObjectDeallocVersionString[];

