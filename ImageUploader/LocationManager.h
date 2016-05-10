//
//  LocationManager.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 1..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManager : NSObject <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLLocation *location;
    
    int count;
}

+ (LocationManager *)sharedInstance;
- (void)startUpdateLocation;
- (void)stopUpdateLocation;

- (CLLocation *)getLocation;


@end
