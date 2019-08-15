//
//  JDMutableWeakDictionary.h
//  JDObjectDealloc
//
//  Created by JD on 2019/8/14.
//

/*
字典里面存储的是weak对象，当里面的对象没有其他引用者时，不管字典释不释放，里面的对象会自动释放
**/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JDMutableWeakDictionary<KeyType,ObjectType> : NSObject

+ (instancetype)standardWeakDictionary;

+ (instancetype)dictionary;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCapacity:(NSUInteger)numItems NS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_DESIGNATED_INITIALIZER;

- (void)setObject:(ObjectType)object forKey:(KeyType <NSCopying>)key;

- (void)removeObjectForKey:(KeyType)aKey;

- (void)removeObjectsForKeys:(NSArray<KeyType> *)keyArray;

- (void)removeAllObjects;

@end

NS_ASSUME_NONNULL_END
