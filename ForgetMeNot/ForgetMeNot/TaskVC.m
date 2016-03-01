//
//  MissionVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/10.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "TaskVC.h"
#import "TaskList.h"
#import "TaskListCreator.h"
#import <JSBadgeView.h>

@interface TaskVC ()

@end

@implementation TaskVC {
    NSArray *_taskList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _taskList = [TaskListCreator creatTaskList];
    for (int i = 0;i < 2;i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:i+1];
        JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:button alignment:JSBadgeViewAlignmentTopRight];
        badgeView.tag = 1001;
        [badgeView setHidden:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    for (int i = 0;i < 2;i++) {
        TaskList *taskList = _taskList[i];
        UIButton *button = (UIButton *)[self.view viewWithTag:i+1];
        if (taskList.isFinished) {
            [button setImage:[UIImage imageNamed:@"任务已处理"] forState:UIControlStateNormal];
            [button setEnabled:NO];
        } else {
            [button setImage:[UIImage imageNamed:@"任务未处理"] forState:UIControlStateNormal];
            [button setEnabled:YES];
        }
        JSBadgeView *badgeView = (JSBadgeView *)[button viewWithTag:1001];
        if (taskList.unfinisedCount != 0) {
            badgeView.badgeText = [NSString stringWithFormat:@"%ld",taskList.unfinisedCount];
            [badgeView setHidden:NO];
        } else {
            [badgeView setHidden:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)beaconButtonPressed:(UIButton *)sender {
    TaskList *taskList = _taskList[sender.tag - 1];
    [self performSegueWithIdentifier:@"taskDetail" sender:taskList];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *controller = segue.destinationViewController;
    [controller setValue:sender forKey:@"taskList"];
}


@end
