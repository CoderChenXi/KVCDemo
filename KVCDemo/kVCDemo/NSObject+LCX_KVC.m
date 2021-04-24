//
//  NSObject+LCX_KVC.m
//  kVCDemo
//
//  Created by lvyongbiao on 2021/4/23.
//

#import "NSObject+LCX_KVC.h"
#import <objc/runtime.h>

@implementation NSObject (LCX_KVC)

//通过key获取值
- (nullable id)lcx_valueForKey:(NSString *)key {
    // 1.判断key不为空
    if (key == nil  || key.length == 0) {
        return nil;
    }
 
    // 2.找到相关方法 get<Key>, <key>, is<Key>, or _<key>
    // key 要大写
    NSString *Key = key.capitalizedString;
    NSString *getKey = [NSString stringWithFormat:@"get%@",Key];
    NSString *isKey = [NSString stringWithFormat:@"is%@",Key];
    NSString *_key = [NSString stringWithFormat:@"_%@",Key];
 
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:NSSelectorFromString(getKey)]) {
        return [self performSelector:NSSelectorFromString(getKey)];
    } else if ([self respondsToSelector:NSSelectorFromString(key)]){
        return [self performSelector:NSSelectorFromString(key)];
    } else if ([self respondsToSelector:NSSelectorFromString(isKey)]){
        return [self performSelector:NSSelectorFromString(isKey)];
    } else if ([self respondsToSelector:NSSelectorFromString(_key)]){
        return [self performSelector:NSSelectorFromString(_key)];
    }
#pragma clang diagnostic pop
     
    // 3.判断是否开启间接访问
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"LCXUnknownKeyException" reason:[NSString stringWithFormat:@"[%@ valueForUndefinedKey:]: this class is not key value coding-compliant for the key name",self] userInfo:nil];
    }
    
     // 4.按照 _<key>, _is<Key>, <key>, or is<Key> 顺序查询实例变量
    NSMutableArray *mArray = [self getIvarListName];
    _key = [NSString stringWithFormat:@"_%@",key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@",Key];
    isKey = [NSString stringWithFormat:@"is%@",Key];
    if ([mArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        return object_getIvar(self, ivar);;
    }else if ([mArray containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        return object_getIvar(self, ivar);;
    }
    
    // 5.抛出异常
    @throw [NSException exceptionWithName:@"LCXUnknownKeyException" reason:[NSString stringWithFormat:@"[%@ %@]: valueForUndefinedKey:%@",self,NSStringFromSelector(_cmd),key] userInfo:nil];
 
    return @"";
}

//通过可以设置值
- (void)lcx_setValue:(nullable id)value forKey:(NSString *)key {
    // 1.判断key不为空
    if (!key || key.length < 1) {
        return;
    }
    
    // 2.找到相关方法 set<Key> _set<Key>
    // key 首字符要大写
    NSString *Key = key.capitalizedString;
    // 拼接方法
    NSString *setKey = [NSString stringWithFormat:@"set%@:",Key];
    NSString *_setKey = [NSString stringWithFormat:@"_set%@:",Key];
    
    if ([self performSelectorWithMethodName:setKey value:value]) {
        NSLog(@"-------------------%@",setKey);
        return;
    } else if ([self performSelectorWithMethodName:_setKey value:value]) {
        NSLog(@"-------------------%@",_setKey);
        return;
    }
    
    // 3.判断是否开启间接访问
    if (![self.class accessInstanceVariablesDirectly]) {
        @throw [NSException exceptionWithName:@"LCXUnknowKeyException" reason:[NSString stringWithFormat:@"[%@valueForUndefinedKey:]: this class is not key value coding-compliant for the key name",self] userInfo:nil];
    }
    
    // 4.查找相关实例变量进行赋值
    // 4.1 定义一个收集实例变量的可变数组
    NSMutableArray *mArray = [self getIvarListName];
    // _<key>, _is<Key>, <key>, or is<Key>
    NSString *_key = [NSString stringWithFormat:@"_%@",key];
    NSString *_isKey = [NSString stringWithFormat:@"_is%@",key.capitalizedString];
    NSString *isKey = [NSString stringWithFormat:@"is%@",key.capitalizedString];
    if ([mArray containsObject:_key]) {
        Ivar ivar = class_getInstanceVariable([self class], _key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    } else if ([mArray containsObject:_isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], _isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    } else if ([mArray containsObject:key]) {
        Ivar ivar = class_getInstanceVariable([self class], key.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    } else if ([mArray containsObject:isKey]) {
        Ivar ivar = class_getInstanceVariable([self class], isKey.UTF8String);
        object_setIvar(self, ivar, value);
        return;
    }
    
    // 5.如果找不到相关实例
    @throw [NSException exceptionWithName:@"LCXUnknowKeyException" reason:[NSString stringWithFormat:@"[%@ %@]: this class is not key value coding-compliant for the key name",self,NSStringFromSelector(_cmd)] userInfo:nil];
}

#pragma mark - Parvite Methods

- (BOOL)performSelectorWithMethodName:(NSString *)methodName value:(id)value {
    if ([self respondsToSelector:NSSelectorFromString(methodName)]) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:NSSelectorFromString(methodName) withObject:value];
#pragma clang diagnostic pop
        return YES;
    }
    return NO;
}

- (NSMutableArray *)getIvarListName {
    
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:1];
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i<count; i++) {
        Ivar ivar = ivars[i];
        const char *ivarNameChar = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:ivarNameChar];
        NSLog(@"ivarName == %@",ivarName);
        [mArray addObject:ivarName];
    }
    free(ivars);
    return mArray;
}

@end
