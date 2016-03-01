//
//  SessionManager.m
//  Youxuetang
//
//  Created by Limingkai on 14-9-17.
//  Copyright (c) 2014年 SINOSOFT. All rights reserved.
//

#import "SessionManager.h"

static NSString *const kUserArchiveKey = @"userEntityKey";
static NSString *const kUserName = @"KUserName";
static NSString *const kUserId = @"kUserId";
static NSString *const kRoleId = @"kRoleId";
static NSString *const kPassword = @"kPassword";

@implementation SessionManager

+ (instancetype)sharedManger {
    
    static SessionManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[[self class] alloc] init];
    });
    return _sharedManager;
}

- (void)saveUsername:(NSString *)username password:(NSString *)password {
    [[NSUserDefaults standardUserDefaults] setObject:username forKey:kUserName];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:kPassword];
}

- (BOOL)isLogin {
    NSString *userName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    return (userName != nil);
}


- (void)logout {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kRoleId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserArchiveKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getUserId {
    
    NSString * successToken=nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserId]) {
        successToken=[[[NSUserDefaults standardUserDefaults] objectForKey:kUserId] stringValue];
    }
    if (successToken) {
        return successToken;
    }
    return @"";
}

- (NSString *)getRoleId {
    
    NSString * successToken=nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kRoleId]) {
        
        successToken=[[NSUserDefaults standardUserDefaults] objectForKey:kRoleId];
    }
    if (successToken.length) {
        return successToken;
    }
    
    else return @"";
}

- (NSString *)getUserName {
    
    NSString * successToken=nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kUserName]) {
        
        successToken=[[NSUserDefaults standardUserDefaults] objectForKey:kUserName];
    }
    if (successToken.length) {
        return successToken;
    }
    else return @"";
}

@end
