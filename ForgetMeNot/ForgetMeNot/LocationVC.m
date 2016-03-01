//
//  LocationVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/13.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "LocationVC.h"
#import "RWTItem.h"
#import "LocationView.h"
#import "CacheManager.h"
#import <CRToast.h>
#import "RWTAppDelegate.h"
#import <SVProgressHUD.h>

@import AVFoundation;

@interface LocationVC () <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet LocationView *locationView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) NSMutableArray *items;

@property (strong, nonatomic) NSMutableArray *recordArray;

@property (strong, nonatomic) CLBeacon *lastBeacon;

@property (strong, nonatomic) AVSpeechSynthesisVoice *voice;
@property (strong, nonatomic) AVSpeechSynthesizer *speechSynthesizer;

@end

@implementation LocationVC {
    NSInteger _recordCount;
    NSString *_locationName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        [_locationManager requestAlwaysAuthorization];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    [self loadItems];
    _voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
}

- (void)loadItems {

    self.items = [NSMutableArray array];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iBeaconList" ofType:@"plist"];
    NSArray *beaconsArray = [NSArray arrayWithContentsOfFile:plistPath];
    if (beaconsArray) {
        for (NSDictionary *dict in beaconsArray) {
            RWTItem *item = [[RWTItem alloc] initWithName:dict[@"name"] uuid:[[NSUUID alloc] initWithUUIDString:dict[@"UUID"]] major:[dict[@"major"] integerValue] minor:[dict[@"minor"] integerValue]];
            [self.items addObject:item];
        }
        [self startMonitoringItem:self.items[0]];
    }
}

- (CLBeaconRegion *)beaconRegionWithItem:(RWTItem *)item {
    
    CLBeaconRegion *beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:item.uuid major:item.majorValue identifier:item.name];
    return beaconRegion;
}

- (void)startMonitoringItem:(RWTItem *)item {
    CLBeaconRegion *beaconRegion = [self beaconRegionWithItem:item];
    if(beaconRegion) {
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

//- (IBAction)recordButtonPressed:(id)sender {
//    int positionx = self.locationView.locationImageView.center.x;
//    int positiony = self.locationView.locationImageView.center.y;
//    NSInteger a1rssi = 0;
//    NSInteger a2rssi = 0;
//    NSInteger a3rssi = 0;
//    for (RWTItem *item in self.items) {
//        if ([item.name isEqualToString:@"A1"]) {
//            a1rssi = item.lastSeenBeacon.rssi;
//        } else if([item.name isEqualToString:@"A2"]) {
//            a2rssi = item.lastSeenBeacon.rssi;
//        } else if([item.name isEqualToString:@"A3"]) {
//            a3rssi = item.lastSeenBeacon.rssi;
//        }
//    }
//    
//    NSDictionary *dict = @{@"positionX":@(positionx),@"positionY":@(positiony),@"a1rssi":@(a1rssi),@"a2rssi":@(a2rssi),@"a3rssi":@(a3rssi)};
//    [self.recordArray addObject:dict];
//}


//- (IBAction)endButtonPressed:(id)sender {
//    [self.recordArray writeToFile:[CacheManager cacheFile:@"recordLocaions.plist"] atomically:YES];
//}


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
    NSLog(@"beacons count is %lu",(unsigned long)beacons.count);
    _locationView.items = beacons;
    if (beacons.count > 0) {
        CLBeacon *beacon1 = beacons[0];
        for (CLBeacon *beacon in beacons) {
            if (beacon.accuracy < beacon1.accuracy && beacon.rssi > beacon1.rssi) {
                beacon1 = beacon;
            }
        }
        NSLog(@"beacon1 accuracy is %f",beacon1.accuracy);
        if(beacon1.accuracy > 1.0f)
            return;
        if([[beacon1.proximityUUID UUIDString] isEqualToString:[self.lastBeacon.proximityUUID UUIDString]] && [beacon1.major isEqualToNumber:self.lastBeacon.major] && [beacon1.minor isEqualToNumber:self.lastBeacon.minor]) {
            return;
        } else {
            self.lastBeacon = beacon1;
            NSLog(@"last beacon is %@,%ld",self.lastBeacon.proximityUUID,[self.lastBeacon.minor integerValue]);
            for (RWTItem *item in self.items) {
                if([item isEqualToCLBeacon:self.lastBeacon]) {
                    _locationName = item.name;
                    break;
                }
            }
            NSString *content = [NSString stringWithFormat:@"你已经进入%@地区",_locationName];
            [self speakWithContent:content];
            [self showToastWithContent:content];
            
        }
    }
}

#pragma mark - Privates Methods

- (void)showToastWithContent:(NSString *)content {
    [SVProgressHUD showSuccessWithStatus:content];
}

- (void)speakWithContent:(NSString *)content {
    [self.speechSynthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
    if (self.voice && content) {
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:content];
        // 设置声音
        utterance.voice = self.voice;
        // 设置说话速率
        utterance.rate *= 0.5;
        // 设置声音大小
        utterance.volume = 0.5;
        [self.speechSynthesizer speakUtterance:utterance];
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
