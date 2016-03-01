//
//  MessageDetailVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/15.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "MessageDetailVC.h"
#import "ReportMessage.h"

@interface MessageDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.reportMessage.photoImage1) {
        self.imageView1.image = [UIImage imageWithContentsOfFile:self.reportMessage.photoImage1];
    }
    if (self.reportMessage.photoImage2) {
        self.imageView2.image = [UIImage imageWithContentsOfFile:self.reportMessage.photoImage2];
    }
    self.textView.text = self.reportMessage.content;
    self.locationLabel.text = self.reportMessage.location;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
