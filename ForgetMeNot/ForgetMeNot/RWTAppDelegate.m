//
//  RWTAppDelegate.m
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/28/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "RWTAppDelegate.h"
#import "SessionManager.h"
#import "CacheManager.h"
#import "ReportMessage.h"
#import <JSBadgeView/JSBadgeView.h>

@import CoreLocation;

@interface RWTAppDelegate () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSArray *reportArray;

@end

@implementation RWTAppDelegate

- (NSArray *)reportArray {
    if(!_reportArray) {
        _reportArray= [NSKeyedUnarchiver unarchiveObjectWithFile:[CacheManager cacheFile:@"reportMessage"]];
        if (!_reportArray) {
            _reportArray = [NSArray array];
        }
    }
    return _reportArray;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[JSBadgeView appearance] setBadgeBackgroundColor:[UIColor redColor]];
    [[JSBadgeView appearance] setBadgeAlignment:JSBadgeViewAlignmentTopRight];
    [[UINavigationBar appearance] setBarTintColor:NAVIGATIONCOLOR];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (![SessionManager sharedManger].isLogin) {
        UIViewController *loginVC = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        self.window.rootViewController = loginVC;
    } else {
        UITabBarController *mainVC = [storyboard instantiateViewControllerWithIdentifier:@"main"];
        
        NSInteger unreadCount = 0;
        for (ReportMessage *reportMessage in self.reportArray) {
            if (![reportMessage.isRead boolValue]) {
                unreadCount ++;
            }
        }
        if(unreadCount == 0) {
            mainVC.childViewControllers[2].tabBarItem.badgeValue = nil;
        } else {
            mainVC.childViewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadCount];
        }

        
        self.window.rootViewController = mainVC;
        
    }

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    if ([region isKindOfClass:[CLBeaconRegion class]]) {
//        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
//        NSLog(@"beaconRegion uuid is %@",beaconRegion.proximityUUID);
//        NSLog(@"distance is %f",beaconRegion.radius);
//    }
//}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = [NSString stringWithFormat:@"你已经离开%@区域",        region.identifier];
        notification.soundName = @"Default";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
}

@end
