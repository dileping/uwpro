//
//  UWLocationManager.m
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import "UWLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface UWLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong, readwrite) CLLocationManager* locationManager;

@end

@implementation UWLocationManager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        self.locationManager = [CLLocationManager new];
        self.locationManager.delegate = self;
//        self.locationManager.distanceFilter = 500.0; //1km movement
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    }
    return self;
}

- (void)dealloc {
    self.locationManager = nil;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* newLocation = [locations lastObject];
    [self.delegate locationManager:self didObtainNewLongitude:newLocation.coordinate.longitude andLatitude:newLocation.coordinate.latitude];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    [self.delegate locationManager:self didObtainError:error];
}

- (void)startLocationService {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted )
    {
        return;
    }
    
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
//        [self.locationManager startMonitoringSignificantLocationChanges];
//        if (self.locationManager.location != nil) {
//            [self locationManager:self.locationManager didUpdateLocations:@[self.locationManager.location]];
//        }
}

- (void)stopLocationService {
//    [self.locationManager stopMonitoringSignificantLocationChanges];
    [self.locationManager stopUpdatingLocation];
}

@end
