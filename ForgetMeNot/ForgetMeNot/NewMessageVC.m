//
//  NewMessageVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/8.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "NewMessageVC.h"
#import "CacheManager.h"
#import "NewMessageCell.h"
#import "RWTItem.h"
#import "ReportMessage.h"

@import CoreLocation;

@interface NewMessageVC () <CLLocationManagerDelegate>

@property (nonatomic ,strong) NSArray *reportArray;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation NewMessageVC


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSArray *)reportArray {
    if(!_reportArray) {
        _reportArray= [NSKeyedUnarchiver unarchiveObjectWithFile:[CacheManager cacheFile:@"reportMessage"]];
        if (!_reportArray) {
            _reportArray = [NSArray array];
        }
    }
    return _reportArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_locationManager requestAlwaysAuthorization];
    }
    [self loadItems];
//    NSMutableArray *array = [NSMutableArray array];
//    for (int i = 0; i <= 400; i++) {
//        int month = random() % 24;
//        NSLog(@"month is %d",month);
//        int positionX = random() % 241;
//        int positionY = random() % 438;
//        int magnitude = random() % 4 + 1;
//        
//        NSDictionary *dict = @{@"hour":@(month),@"positionX":@(positionX),@"positionY":@(positionY),@"magnitude":@(magnitude)};
//        [array addObject:dict];
//    }
//    [array writeToFile:[CacheManager cacheFile:@"locations.plist"] atomically:YES];
//    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
    NSInteger unreadCount = 0;
    for (ReportMessage *reportMessage in self.reportArray) {
        if (![reportMessage.isRead boolValue]) {
            unreadCount ++;
        }
    }
    if (unreadCount == 0) {
        self.parentViewController.tabBarController.childViewControllers[2].tabBarItem.badgeValue = nil;
    } else {
        self.parentViewController.tabBarController.childViewControllers[2].tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadCount];
    }
    [NSKeyedArchiver archiveRootObject:self.reportArray toFile:[CacheManager cacheFile:@"reportMessage"]];
}

- (void)loadItems {
    
    self.items = [NSMutableArray array];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iBeaconList" ofType:@"plist"];
    NSArray *beaconsArray = [NSArray arrayWithContentsOfFile:plistPath];
    if (beaconsArray) {
        for (NSDictionary *dict in beaconsArray) {
            RWTItem *item = [[RWTItem alloc] initWithName:dict[@"name"] uuid:[[NSUUID alloc] initWithUUIDString:dict[@"UUID"]] major:[dict[@"major"] integerValue] minor:[dict[@"minor"] integerValue]];
            [self.items addObject:item];
            [self startMonitoringItem:item];
        }
    }
}

- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid
                                                                           major:item.majorValue
                                                                           minor:item.minorValue
                                                                      identifier:item.name];
    beaconRegion.notifyOnEntry = YES;
    beaconRegion.notifyOnExit = YES;
    beaconRegion.notifyEntryStateOnDisplay = YES;
    return beaconRegion;
}

- (void)startMonitoringItem:(RWTItem *)item {
    NSLog(@"start monitor");
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    if(beaconRegion) {
        
        NSLog(@"beaconRegion name is %@",beaconRegion.identifier);
        
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.reportArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newMessageCell" forIndexPath:indexPath];
    cell.reportMessage = self.reportArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReportMessage *reportMessage = self.reportArray[indexPath.row];
    reportMessage.isRead = @(YES);
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self performSegueWithIdentifier:@"messageDetail" sender:self.reportArray[indexPath.row]];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
               inRegion:(CLBeaconRegion *)region
{

}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    NSLog(@"come region is %@",region.identifier);
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        for (ReportMessage *reportMesage in self.dataArray) {
            if ([reportMesage.location isEqualToString:region.identifier]) {
                [self.dataArray removeObject:reportMesage];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
            NSLog(@"region identifier is %@",region.identifier);
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        for (ReportMessage *reportMesage in self.dataArray) {
            if ([reportMesage.location isEqualToString:region.identifier]) {
                [self.dataArray addObject:reportMesage];
            }
        }
    }
        [self.tableView reloadData];
}

 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     [segue.destinationViewController setValue:sender forKey:@"reportMessage"];
 }


@end
