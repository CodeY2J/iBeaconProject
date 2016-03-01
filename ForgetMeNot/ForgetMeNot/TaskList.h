//
//  TaskList.h
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/12.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskList : NSObject

@property (nonatomic, assign,getter=isFinished) BOOL finished;
@property (nonatomic,copy) NSArray *tasks;
@property (nonatomic,assign) NSInteger unfinisedCount;

@end
