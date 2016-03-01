//
//  EquipmentVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/9/25.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "EquipmentVC.h"
#import <CoreLocation/CoreLocation.h>
#import "RWTItem.h"

@interface EquipmentVC () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) CLBeacon *lastBeacon;
@property (strong, nonatomic) NSArray *beaconsArray;

@end

@implementation EquipmentVC {
    NSArray *_A1Array;
    NSArray *_A2Array;
    NSArray *_A3Array;
}

- (NSArray *)beaconsArray {
    if(!_beaconsArray) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iBeaconList" ofType:@"plist"];
        _beaconsArray = [NSArray arrayWithContentsOfFile:plistPath];
    }
    return _beaconsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [[NSArray alloc] init];
    _A1Array = @[@"灭火器",@"氧气瓶"];
    _A2Array = @[@"急救箱",@"麦克风"];
    _A3Array = @[@"救生衣",@"手电筒"];
     [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_locationManager requestAlwaysAuthorization];
    }
    [self loadItems];
    self.dataArray = @[@"灭火器",@"氧气瓶",@"急救箱",@"麦克风",@"救生衣",@"手电筒"];
}

- (void)loadItems {
    
    self.items = [NSMutableArray array];

    if (self.beaconsArray) {
        for (NSDictionary *dict in self.beaconsArray) {
            RWTItem *item = [[RWTItem alloc] initWithName:dict[@"name"] uuid:[[NSUUID alloc] initWithUUIDString:dict[@"UUID"]] major:[dict[@"major"] integerValue] minor:[dict[@"minor"] integerValue]];
            [self.items addObject:item];
        }
        NSLog(@"self items is %@",self.beaconsArray);
        [self startMonitoringItem:self.items[0]];
    }
}

- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {

    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid major:item.majorValue identifier:item.name];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"equipmentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - TableView delegates

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"extinguisherDetail" sender:self.dataArray[indexPath.row]];
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
               inRegion:(CLBeaconRegion *)region {
    if (beacons.count > 0) {
        CLBeacon *beacon1 = beacons[0];
        for (CLBeacon *beacon in beacons) {
            if (beacon.accuracy < beacon1.accuracy && beacon.rssi > beacon1.rssi) {
                beacon1 = beacon;
            }
        }
        if([[beacon1.proximityUUID UUIDString] isEqualToString:[self.lastBeacon.proximityUUID UUIDString]] && [beacon1.major isEqualToNumber:self.lastBeacon.major] && [beacon1.minor isEqualToNumber:self.lastBeacon.minor]) {
            return;
        } else {
            self.lastBeacon = beacon1;
            if ([self.items[0] isEqualToCLBeacon:beacon1]) {
                self.dataArray = _A1Array;
            } else if([self.items[1] isEqualToCLBeacon:beacon1]) {
                self.dataArray = _A2Array;
            } else if([self.items[2] isEqualToCLBeacon:beacon1]) {
                self.dataArray = _A3Array;
            }
            [self.tableView reloadData];
        }
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    [vc setValue:sender forKey:@"equipment"];
    
}


@end
