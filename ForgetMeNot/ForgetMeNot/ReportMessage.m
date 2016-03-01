//
//  ReportMessage.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/8.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "ReportMessage.h"

static NSString *const kContent     = @"kContent";
static NSString *const kLocation    = @"kLocation";
static NSString *const kTime        = @"kTime";
static NSString *const kPhotoImage1 = @"kPhotoImage1";
static NSString *const kPhotoImage2 = @"kPhotoImage2";
static NSString *const kIsRead      = @"kIsRead";

@implementation ReportMessage

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_content forKey:kContent];
    [aCoder encodeObject:_location forKey:kLocation];
    [aCoder encodeObject:_time forKey:kTime];
    [aCoder encodeObject:_photoImage1 forKey:kPhotoImage1];
    [aCoder encodeObject:_photoImage2 forKey:kPhotoImage2];
    [aCoder encodeObject:_isRead forKey:kIsRead];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _content = [aDecoder decodeObjectForKey:kContent];
        _location = [aDecoder decodeObjectForKey:kLocation];
        _time = [aDecoder decodeObjectForKey:kTime];
        _photoImage1 = [aDecoder decodeObjectForKey:kPhotoImage1];
        _photoImage2 = [aDecoder decodeObjectForKey:kPhotoImage2];
        _isRead = [aDecoder decodeObjectForKey:kIsRead];
    }
    return self;
}

@end
