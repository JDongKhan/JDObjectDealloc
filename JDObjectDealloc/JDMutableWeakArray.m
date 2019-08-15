//
//  JDMutableWeakArray.m
//  JDObjectDealloc
//
//  Created by JD on 2019/8/14.
//  Copyright © 2019 JD. All rights reserved.
//

#import "JDMutableWeakArray.h"
#import "NSObject+JDDeallocBlock.h"

@protocol JDArrayWeakReferenceWrapperDelegate <NSObject>
- (void)objectWillDealloc:(id)object;
@end

@interface JDArrayWeakReferenceWrapper : NSObject
@property (nonatomic, weak) id<JDArrayWeakReferenceWrapperDelegate> delegate;
@property (nonatomic, weak) id object;
- (instancetype)initWithWeakObject:(id)object
                          delegate:(id<JDArrayWeakReferenceWrapperDelegate>)delegate;
@end

@implementation JDArrayWeakReferenceWrapper
- (instancetype)initWithWeakObject:(id)object
                          delegate:(id<JDArrayWeakReferenceWrapperDelegate>)delegate {
    if (self = [super init]) {
        self.object = object;
        self.delegate = delegate;
        __weak JDArrayWeakReferenceWrapper *weakSelf = self;
        [self.object jd_executeAtDealloc:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(objectWillDealloc:)]) {
                [weakSelf.delegate objectWillDealloc:weakSelf];
            }
        }];
    }
    return self;
}
@end


@interface JDMutableWeakArray()<JDArrayWeakReferenceWrapperDelegate>

@property (nonatomic, strong) NSMutableArray<JDArrayWeakReferenceWrapper *> *weakArray;

@end

@implementation JDMutableWeakArray

+ (instancetype)standardWeakArray {
    static dispatch_once_t onceToken;
    static JDMutableWeakArray *weakArray = nil;
    dispatch_once(&onceToken, ^{
        weakArray = [[JDMutableWeakArray alloc] init];
    });
    return weakArray;
}

+ (instancetype)array {
    return [[JDMutableWeakArray alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _weakArray = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        _weakArray = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _weakArray = [[NSMutableArray alloc] initWithCoder:coder];
    }
    return self;
}


- (void)addObject:(id)object {
    JDArrayWeakReferenceWrapper *wrapper = [[JDArrayWeakReferenceWrapper alloc] initWithWeakObject:object delegate:self];
    [_weakArray addObject:wrapper];
}

- (void)addObjectsFromArray:(NSArray *)otherArray {
    [otherArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JDArrayWeakReferenceWrapper *wrapper = [[JDArrayWeakReferenceWrapper alloc] initWithWeakObject:obj delegate:self];
        [_weakArray addObject:wrapper];
    }];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    JDArrayWeakReferenceWrapper *wrapper = [[JDArrayWeakReferenceWrapper alloc] initWithWeakObject:anObject delegate:self];
    [_weakArray insertObject:wrapper atIndex:index];
}

- (void)exchangeObjectAtIndex:(NSUInteger)idx1 withObjectAtIndex:(NSUInteger)idx2 {
    [_weakArray exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    JDArrayWeakReferenceWrapper *wrapper = [[JDArrayWeakReferenceWrapper alloc] initWithWeakObject:anObject delegate:self];
    [_weakArray replaceObjectAtIndex:index withObject:wrapper];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    [_weakArray removeObjectAtIndex:index];
}

- (void)removeObject:(id)object {
    NSUInteger index = [_weakArray indexOfObjectPassingTest:^BOOL(JDArrayWeakReferenceWrapper  *_Nonnull obj, __unused NSUInteger idx, __unused BOOL * _Nonnull stop) {
        return obj.object == object;
    }];
    if (index != NSNotFound) {
        [_weakArray removeObjectAtIndex:index];
    }
}

- (void)removeAllObjects {
    [_weakArray removeAllObjects];
}


- (void)sortUsingComparator:(NSComparator NS_NOESCAPE)cmptr {
    [_weakArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (cmptr) {
            return cmptr(obj1,obj2);
        }
        return NSOrderedAscending;
    }];
}

- (void)sortWithOptions:(NSSortOptions)opts usingComparator:(NSComparator NS_NOESCAPE)cmptr {
    [_weakArray sortWithOptions:opts usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (cmptr) {
            return cmptr(obj1,obj2);
        }
        return NSOrderedAscending;
    }];
}

- (NSUInteger)count {
    return _weakArray.count;
}

- (id)firstObject {
    return [_weakArray firstObject].object;
}

- (id)lastObject {
    return [_weakArray lastObject].object;
}

- (void)objectWillDealloc:(id)object {
    [_weakArray removeObject:object];
}


@end


