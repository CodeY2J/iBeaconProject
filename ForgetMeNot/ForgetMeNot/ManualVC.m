//
//  ManualVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/25.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "ManualVC.h"

@interface ManualVC ()

@end

@implementation ManualVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"manualSub" sender:@(indexPath.row)];
    NSLog(@"index path is %@",indexPath);
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    [vc setValue:sender forKey:@"manualType"];
}


@end
