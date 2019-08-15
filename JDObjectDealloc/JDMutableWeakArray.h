//
//  JDMutableWeakArray.h
//  JDObjectDealloc
//
//  Created by JD on 2019/8/14.
//  Copyright © 2019 JD. All rights reserved.
//
/*
 数组里面存储的是weak对象，当里面的对象没有其他引用者时，不管数组释不释放，里面的对象会自动释放
 **/
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMutableWeakArray<ObjectType> : NSObject

@property (nullable, nonatomic, readonly) ObjectType firstObject;
@property (nullable, nonatomic, readonly) ObjectType lastObject;

@property (readonly) NSUInteger count;

+ (instancetype)standardWeakArray;

+ (instancetype)array;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

- (void)addObject:(ObjectType)object;

- (void)addObjectsFromArray:(NSArray<ObjectType> *)otherArray;

- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2;

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

- (void)removeObjectAtIndex:(NSUInteger)index;

- (void)removeObject:(ObjectType)object;

- (void)removeAllObjects;

- (void)sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));

- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmptr API_AVAILABLE(macos(10.6), ios(4.0), watchos(2.0), tvos(9.0));


@end

NS_ASSUME_NONNULL_END
