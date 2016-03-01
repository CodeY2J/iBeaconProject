//
//  NewMessageCell.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/8.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "NewMessageCell.h"

@implementation NewMessageCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setReportMessage:(ReportMessage *)reportMessage {
    if (reportMessage.photoImage1) {
        self.photoImageView1.image = [UIImage imageWithContentsOfFile:reportMessage.photoImage1];
    }
    if (reportMessage.photoImage2) {
        self.photoImageView2.image = [UIImage imageWithContentsOfFile:reportMessage.photoImage2];
    }
    self.contentLabel.text = reportMessage.content;
    self.locationLabel.text = reportMessage.location;
    self.timeLabel.text = reportMessage.time;
    
    if([reportMessage.isRead boolValue]) {
        self.contentLabel.textColor = [UIColor grayColor];
        self.locationLabel.textColor = [UIColor grayColor];
        self.timeLabel.textColor = [UIColor grayColor];
    } else {
        self.contentLabel.textColor = [UIColor blackColor];
        self.locationLabel.textColor = [UIColor blackColor];
        self.timeLabel.textColor = [UIColor blackColor];
    }
}

@end
