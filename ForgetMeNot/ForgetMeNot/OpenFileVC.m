//
//  OpenFileVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/24.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "OpenFileVC.h"

@interface OpenFileVC ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation OpenFileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:_fileName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];

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
