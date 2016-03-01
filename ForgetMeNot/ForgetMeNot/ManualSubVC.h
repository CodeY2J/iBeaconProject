//
//  ManualSubVC.h
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/25.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManualSubVC : UITableViewController

/*
 * 0 使用手册
 * 1 维修手册
 * 2 重大事项
 */
@property (nonatomic, strong) NSNumber *manualType;

@end
