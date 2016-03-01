//
//  LoginVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/23.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "SessionManager.h"
#import "LoginVC.h"

@interface LoginVC ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *usernamgeImage = [UIImage imageNamed:@"login_username"];
    self.usernameTextField.leftView = [[UIImageView alloc] initWithImage:usernamgeImage];
    self.usernameTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImage *passwordImage = [UIImage imageNamed:@"login_password"];
    self.passwordTextField.leftView = [[UIImageView alloc] initWithImage:passwordImage];
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonPressed:(id)sender {
    if([self.usernameTextField.text isEqualToString:@""] || [self.passwordTextField.text isEqualToString:@""]) {
        return;
    }

    if ([self.usernameTextField.text isEqualToString:@"test123"] && [self.passwordTextField.text isEqualToString:@"123456"]) {
        [[SessionManager sharedManger] saveUsername:self.usernameTextField.text password:self.passwordTextField.text];
        UIViewController *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"main"];
        [[UIApplication sharedApplication].delegate window].rootViewController = mainVC;
    }
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
