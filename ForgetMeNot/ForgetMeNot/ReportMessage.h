//
//  ReportMessage.h
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/8.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReportMessage : NSObject <NSCoding>

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *photoImage1;
@property (nonatomic, strong) NSString *photoImage2;
@property (nonatomic, strong) NSNumber *isRead;

@end
