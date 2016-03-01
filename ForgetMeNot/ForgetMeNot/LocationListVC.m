//
//  LocationVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/8.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "LocationListVC.h"

@implementation LocationListVC


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            _location = @"A1";
            break;
        case 1:
            _location = @"A2";
            break;
        case 2:
            _location = @"A3";
            break;
        default:
            break;
    }

}

@end
