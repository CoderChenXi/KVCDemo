//
//  AppDelegate.m
//  kVCDemo
//
//  Created by lvyongbiao on 2021/4/23.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _winodw = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _winodw.rootViewController = [[ViewController alloc] init];
    [_winodw makeKeyAndVisible];
    return YES;
}

@end
