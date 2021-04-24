//
//  NSObject+LCX_KVC.h
//  kVCDemo
//
//  Created by lvyongbiao on 2021/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LCX_KVC)

//通过key获取值
- (nullable id)lcx_valueForKey:(NSString *)key;

//通过可以设置值
- (void)lcx_setValue:(nullable id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
