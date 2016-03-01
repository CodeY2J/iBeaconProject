//
//  LocationView.m
//  ForgetMeNot
//
//  Created by Limingkai on 15/10/13.
//  Copyright © 2015年 Ray Wenderlich Tutorial Team. All rights reserved.
//

#import "LocationView.h"
#import "RWTItem.h"

#define pi 3.14159265358979323846
#define radiansToDegrees(x) (180.0 * x / pi)

@interface LocationView ()

@property (strong, nonatomic) NSArray *recordLoactions;
@property (strong, nonatomic) NSArray *beaconsArray;

@end

@implementation LocationView {
    int count;
    CLBeacon *_beacona1;
    CLBeacon *_beacona2;
    CLBeacon *_beacona3;
}

- (NSArray *)beaconsArray {
    if (!_beaconsArray) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"iBeaconList" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:3];
        for (NSDictionary *dict in array) {
            RWTItem *item = [[RWTItem alloc] initWithName:dict[@"name"] uuid:[[NSUUID alloc] initWithUUIDString:dict[@"UUID"]] major:[dict[@"major"] integerValue] minor:[dict[@"minor"] integerValue]];
            [mutableArray addObject:item];
        }
        _beaconsArray = mutableArray;
    }
    return _beaconsArray;
}

- (NSArray *)recordLoactions {
    if (!_recordLoactions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"recordLocaions" ofType:@"plist"];
        NSArray *array = [NSArray arrayWithContentsOfFile:path];
        if (!array) {
            array = [NSArray array];
        }
        _recordLoactions = array;
    }
    return _recordLoactions;
}

- (void)setItems:(NSArray *)items {
    _items = items;
//    if (count!=20) {
//        count++;
//    } else {
//        [self setNeedsDisplay];
//    }
    for (CLBeacon *beacon in items) {
        if ([self.beaconsArray[0] isEqualToCLBeacon:beacon]) {
            _beacona1 = beacon;
        } else if([self.beaconsArray[1] isEqualToCLBeacon:beacon]) {
            _beacona2 = beacon;
        } else if([self.beaconsArray[2] isEqualToCLBeacon:beacon]) {
            _beacona3 = beacon;
        }
    }
    for (NSDictionary *dict in self.recordLoactions) {
        if (labs([dict[@"a1rssi"] integerValue] - _beacona1.rssi) <= 4 && \
            labs([dict[@"a2rssi"] integerValue] - _beacona2.rssi) <= 4 &&\
            labs([dict[@"a3rssi"] integerValue] - _beacona3.rssi) <= 4) {
            NSInteger positionX = [dict[@"positionX"] integerValue];
            NSInteger positionY = [dict[@"positionY"] integerValue];
            CGPoint point = CGPointMake(positionX, positionY);
            [self setLocationCenter:point];
            break;
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"dw_map"];
    [image drawInRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*边框圆
     */
    CGContextSetRGBStrokeColor(context, 255/255.0, 106/255.0, 0/255.0, 1);
    CGContextSetLineWidth(context, 2);

    NSInteger radius1 = sqrt(pow(self.locationImageView.center.x,2) + pow(self.locationImageView.center.y, 2));
    NSInteger radius2 = sqrt(pow(self.locationImageView.center.x,2) + pow(fabs(self.locationImageView.center.y - self.frame.size.height), 2));
    NSInteger radius3 = sqrt(pow(fabs(self.locationImageView.center.x - self.frame.size.width),2) + pow(fabs(self.locationImageView.center.y - self.frame.size.height), 2));
    CGContextAddArc(context, 0, 0,radius1, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextAddArc(context, 0, self.frame.size.height,radius2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
    CGContextAddArc(context, self.frame.size.width, self.frame.size.height, radius3, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathStroke);
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _locationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dw_mark"]];
        _locationImageView.center = self.center;
        [self addSubview:_locationImageView];
        NSLog(@"self.frame is %f,%f",self.frame.size.width,self.frame.size.height);
    }
    return self;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    //self.locationImageView.center = currentPosition;
    [self setLocationCenter:currentPosition];
}

- (void)setLocationCenter:(CGPoint)point {
    self.locationImageView.center = point;
    [self setNeedsDisplay];
}

@end
