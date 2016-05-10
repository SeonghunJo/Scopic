//
//  LocationManager.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 1..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "LocationManager.h"

@implementation LocationManager
static LocationManager *__sharedInstance;

+ (LocationManager *)sharedInstance
{
    @synchronized(self)
    {
        if(__sharedInstance == nil)
        {
            __sharedInstance = [[self alloc] init];
        }
    }
    return __sharedInstance;
}

- (id) init
{
    if (self = [super init])
    {
        NSLog(@"Shared LocationManager Init");
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        [locationManager setDelegate:self];
        
        location = [[CLLocation alloc] init];
        count = 0;
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    location = locations.lastObject;
    NSLog(@"%@", location.description);
    count++;
    if(count > 10)
    {
        count = 0;
        [self stopUpdateLocation];
    }
}


- (void)startUpdateLocation
{
    [locationManager startUpdatingLocation];
}

- (void)stopUpdateLocation
{
    [locationManager stopUpdatingLocation];
}

- (CLLocation *)getLocation
{
    return location;
}

@end
