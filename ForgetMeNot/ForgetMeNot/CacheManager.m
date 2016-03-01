//
//  CacheManager.m
//  Youxuetang
//
//  Created by Limingkai on 14-9-23.
//  Copyright (c) 2014年 SINOSOFT. All rights reserved.
//

#import "CacheManager.h"
#import "SessionManager.h"

@implementation CacheManager

+ (CacheManager *)sharedManager {
    
    static CacheManager *_sharedManger = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManger = [[CacheManager alloc] init];
    });
    return _sharedManger;
}

+ (NSString *)cacheFile:(NSString *)fileName {
    
    NSString *path = [[self userCachePath] stringByAppendingPathComponent:fileName];
    return path;
}

+ (NSString *)userCachePath {
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:path]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
