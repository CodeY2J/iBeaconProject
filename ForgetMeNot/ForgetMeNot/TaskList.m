//
//  TaskList.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/12.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "TaskList.h"
#import "Task.h"

@implementation TaskList

- (BOOL)isFinished {
    for (Task *task in _tasks) {
        if (!task.isFinished) {
            return NO;
        }
    }
    return YES;
}

- (NSInteger)unfinisedCount {
    NSInteger count = 0;
    for (Task *task in _tasks) {
        if (!task.isFinished) {
            count++;
        }
    }
    return count;
}

@end
