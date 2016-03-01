//
//  TrailVC.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/10.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "TrailVC.h"
#import "LFHeatMap.h"
#import "DataPickView.h"

@interface TrailVC ()

@property (weak, nonatomic) IBOutlet UIImageView *mapView;
@property (strong, nonatomic) NSArray *locationArray;
@property (weak,nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) NSMutableArray *locations;
@property (strong,nonatomic) NSMutableArray *weights;

@end

@implementation TrailVC {
    NSInteger _startTime;
    NSInteger _endTime;
    NSArray *_pickArray;
}

static NSString *const kPositionX = @"positionX";
static NSString *const kPositionY = @"positionY";
static NSString *const kMagnitude = @"magnitude";
static NSString *const kHour = @"hour";

- (NSArray *)locationArray {
    if (!_locationArray) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"plist"];
        _locationArray = [NSArray arrayWithContentsOfFile:path];
    }
    return _locationArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _startTime = 0;
    _endTime = 24;
    _pickArray = @[@"0:00",@"1:00",@"2:00",@"3:00",@"4:00",@"5:00",@"6:00",@"7:00",@"8:00",@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00",@"16:00",@"17:00",@"18:00",@"19:00",@"20:00",@"21:00",@"22:00",@"23:00",@"24:00"];
    
    self.locations = [NSMutableArray arrayWithCapacity:self.locationArray.count];
    self.weights = [NSMutableArray arrayWithCapacity:self.locationArray.count];
    [self showHeatMapWithStartTime:0 endTime:24];

}

- (void)showHeatMapWithStartTime:(NSInteger)startTime endTime:(NSInteger)endTime {
    if (endTime < startTime) {
        return;
    } else {
        [self.locations removeAllObjects];
        [self.weights removeAllObjects];
        for (NSDictionary *reading in self.locationArray)
        {
            if ([[reading objectForKey:kHour] integerValue] >= startTime && [[reading objectForKey:kHour] integerValue] <= endTime) {
                NSInteger positionX = [[reading objectForKey:kPositionX] integerValue];
                NSInteger positionY = [[reading objectForKey:kPositionY] integerValue];
                double magnitude = [[reading objectForKey:kMagnitude] doubleValue];
                
                CGPoint point = CGPointMake(positionX, positionY);
                NSValue *value = [NSValue valueWithCGPoint:point];
                [self.locations addObject:value];
                [self.weights addObject:[NSNumber numberWithInteger:(magnitude * 10)]];
            }
        }
        
        UIImage *heatmap = [LFHeatMap heatMapWithRect:_mapView.bounds boost:0.3f points:self.locations weights:self.weights];
        self.imageView.image = heatmap;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions
- (IBAction)timeButtonPressed:(UIButton *)sender {
    DataPickView *dataPickView = [[DataPickView alloc] initWithTitle:@"" handler:^(NSInteger seletedIndex) {
        NSString *seletedString = [_pickArray objectAtIndex:seletedIndex];
        [sender setTitle:seletedString forState:UIControlStateNormal];
        switch (sender.tag) {
            case 0:
                _startTime = seletedIndex;
                break;
            case 1:
                _endTime = seletedIndex;
                break;
            default:
                break;
        }
        [self showHeatMapWithStartTime:_startTime endTime:_endTime];
        
    }];
    dataPickView.pickerArray = _pickArray;
    [dataPickView showInView:self.view];
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
