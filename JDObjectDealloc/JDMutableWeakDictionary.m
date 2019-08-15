//
//  JDMutableWeakDictionary.m
//  JDObjectDealloc
//
//  Created by JD on 2019/8/14.
//

#import "JDMutableWeakDictionary.h"
#import "NSObject+JDDeallocBlock.h"


@protocol JDDictionaryWeakReferenceWrapperDelegate <NSObject>
- (void)objectWillDealloc:(id)object forKey:(id<NSCopying>)key;
@end


@interface JDDictionaryWeakReferenceWrapper : NSObject
@property (nonatomic, weak) id object;
@property (nonatomic, copy) id key;
@property (nonatomic, weak) id<JDDictionaryWeakReferenceWrapperDelegate> delegate;
- (instancetype)initWithWeakObject:(id)object
                            forKey:(id<NSCopying>)key
                          delegate:(id<JDDictionaryWeakReferenceWrapperDelegate>)delegate;
@end

@implementation JDDictionaryWeakReferenceWrapper
- (instancetype)initWithWeakObject:(id)object
                            forKey:(id<NSCopying>)key
                          delegate:(id<JDDictionaryWeakReferenceWrapperDelegate>)delegate {
    if (self = [super init]) {
        self.object = object;
        self.delegate = delegate;
        __weak JDDictionaryWeakReferenceWrapper *weakSelf = self;
        [self.object jd_executeAtDealloc:^{
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(objectWillDealloc:forKey:)]) {
                [weakSelf.delegate objectWillDealloc:weakSelf forKey:weakSelf.key];
            }
        }];
    }
    return self;
}
@end


@interface JDMutableWeakDictionary()<JDDictionaryWeakReferenceWrapperDelegate>

@end

@implementation JDMutableWeakDictionary {
    NSMutableDictionary<id<NSCopying>,JDDictionaryWeakReferenceWrapper *> *_weakDictionary;
}

+ (instancetype)standardWeakDictionary {
    static dispatch_once_t onceToken;
    static JDMutableWeakDictionary *weakDictionary = nil;
    dispatch_once(&onceToken, ^{
        weakDictionary = [[JDMutableWeakDictionary alloc] init];
    });
    return weakDictionary;
}

+ (instancetype)dictionary {
    return [[JDMutableWeakDictionary alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _weakDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self) {
        _weakDictionary = [[NSMutableDictionary alloc] initWithCapacity:numItems];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        _weakDictionary = [[NSMutableDictionary alloc] initWithCoder:coder];
    }
    return self;
}

- (void)setObject:(id)object forKey:(id)key {
    JDDictionaryWeakReferenceWrapper *wrapper = [[JDDictionaryWeakReferenceWrapper alloc] initWithWeakObject:object forKey:key delegate:self];
    [_weakDictionary setObject:wrapper forKey:key];
}

- (void)removeObjectForKey:(id)key {
    [_weakDictionary removeObjectForKey:key];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray {
    [_weakDictionary removeObjectsForKeys:keyArray];
}

- (void)removeAllObjects {
    [_weakDictionary removeAllObjects];
}

- (void)objectWillDealloc:(id)object forKey:(id<NSCopying>)key {
    [_weakDictionary removeObjectForKey:key];
}

@end
