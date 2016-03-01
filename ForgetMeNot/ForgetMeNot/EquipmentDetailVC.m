//
//  EquipmentDetailVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/25.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "EquipmentDetailVC.h"

@interface EquipmentDetailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation EquipmentDetailVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.equipment;
    self.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@介绍",self.equipment]];
}

@end
