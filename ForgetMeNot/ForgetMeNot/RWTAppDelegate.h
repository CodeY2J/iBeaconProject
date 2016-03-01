//
//  RWTAppDelegate.h
//  ForgetMeNot
//
//  Created by Chris Wagner on 1/28/14.
//  Copyright (c) 2014 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#define NAVIGATIONCOLOR [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1]

typedef NS_ENUM(NSInteger,Equipment) {
    灭火器 = 0,
    氧气瓶 = 1,
    急救箱 = 2,
    麦克风 = 3,
    救生衣 = 4,
    手电筒 = 5
    
};

@interface RWTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
