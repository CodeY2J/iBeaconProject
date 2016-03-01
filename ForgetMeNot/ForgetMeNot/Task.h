//
//  Task.h
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/12.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign,getter=isFinished) BOOL finished;

@end
