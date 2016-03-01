//
//  SessionManager.h
//  Youxuetang
//
//  Created by Limingkai on 14-9-17.
//  Copyright (c) 2014年 SINOSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionManager : NSObject


+ (instancetype)sharedManger;

- (void)logout;
- (BOOL)isLogin;
- (void)saveUsername:(NSString *)username password:(NSString *)password;

- (NSString *)getUserId;
- (NSString *)getRoleId;
- (NSString *)getUserName;

@end
