//
//  Person.m
//  kVCDemo
//
//  Created by lvyongbiao on 2021/4/24.
//

#import "Person.h"

@implementation Person

+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

#pragma mark - getter相关
//// 1
//- (NSString *)getName {
//    NSLog(@"%s",__func__);
//    return NSStringFromSelector(_cmd);
//}
//
//// 2
//- (NSString *)name {
//    NSLog(@"%s",__func__);
//    return NSStringFromSelector(_cmd);
//}
//
//// 3
//- (NSString *)isName {
//    NSLog(@"%s",__func__);
//    return NSStringFromSelector(_cmd);
//}
//
////4
//- (NSString *)_name {
//    NSLog(@"%s",__func__);
//    return NSStringFromSelector(_cmd);
//}

#pragma mark - setter相关

//- (void)setName:(NSString *)name {
//    NSLog(@"%s",__func__);
//}
//
//- (void)_setName:(NSString *)name {
//    NSLog(@"%s",__func__);
//}


@end
