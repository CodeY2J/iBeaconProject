//
//  ManualSubVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/25.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "ManualSubVC.h"

@interface ManualSubVC ()

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ManualSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    switch ([self.manualType intValue]) {
        case 0:
            self.navigationItem.title = @"使用手册";
            _dataArray = @[@"消防安全操作手册.doc",@"安全消防手册.doc"];
            break;
        case 1:
            self.navigationItem.title = @"维修手册";
            _dataArray = @[@"火电厂大修管理手册.doc"];
            break;
        case 2:
            self.navigationItem.title = @"重大事项";
            _dataArray = @[@"电厂重大事项汇报制度.doc"];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifer = @"manualSubCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}


#pragma mark - TableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"fileVC" sender:self.dataArray[indexPath.row]];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    [vc setValue:sender forKey:@"fileName"];
}


@end
