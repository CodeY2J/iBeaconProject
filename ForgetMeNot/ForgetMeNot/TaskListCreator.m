//
//  TaskListCreator.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/12.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "TaskListCreator.h"
#import "Task.h"
#import "TaskList.h"

@implementation TaskListCreator


+ (NSArray *)creatTaskList {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 2; i++) {
        TaskList *taskList = [[TaskList alloc] init];
        Task *task1 = [[Task alloc] init];
        task1.content = @"维修电表";
        task1.finished = NO;
        
        Task *task2 = [[Task alloc] init];
        task2.content = @"维修电机";
        task2.finished = NO;
        
        Task *task3 = [[Task alloc] init];
        task3.content = @"维修风扇";
        task3.finished = NO;
        
        taskList.tasks = @[task1,task2,task3];
        taskList.finished = NO;
        
        [array addObject:taskList];
    }
    return array;
}

@end
