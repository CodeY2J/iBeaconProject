//
//  CacheManager.h
//  Youxuetang
//
//  Created by Limingkai on 14-9-23.
//  Copyright (c) 2014年 SINOSOFT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (CacheManager *)sharedManager;
+ (NSString *)cacheFile:(NSString *)fileName;

@end
