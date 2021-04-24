//
//  ViewController.m
//  kVCDemo
//
//  Created by lvyongbiao on 2021/4/23.
//

#import "ViewController.h"

#import "Person.h"

#import "NSObject+LCX_KVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *p = [[Person alloc] init];
//    p->_isName = @"123";
//    NSString *name = [p lcx_valueForKey:@"_isName"];
//    NSLog(@"%@",name);
    
    [p lcx_setValue:@"256" forKey:@"name"];
    NSString *name = [p lcx_valueForKey:@"name"];
    NSLog(@"%@",name);
}


@end
