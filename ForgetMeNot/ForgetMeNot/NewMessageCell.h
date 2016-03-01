//
//  NewMessageCell.h
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/8.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReportMessage.h"

@interface NewMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView2;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) ReportMessage *reportMessage;

@end
