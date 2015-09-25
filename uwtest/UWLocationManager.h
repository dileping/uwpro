//
//  UWLocationManager.h
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UWLocationManagerDelegate;

@interface UWLocationManager : NSObject

@property (nonatomic, assign, readwrite) id<UWLocationManagerDelegate> delegate;

- (void)startLocationService;
- (void)stopLocationService;

@end


@protocol UWLocationManagerDelegate <NSObject>

- (void)locationManager:(UWLocationManager*)manager didObtainNewLongitude:(double)lon andLatitude:(double)lat;
- (void)locationManager:(UWLocationManager*)manager didObtainError:(NSError*)error;

@end
