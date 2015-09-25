//
//  ViewController.m
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import "ViewController.h"
#import "UWLocationManager.h"
#import "uwtest-Swift.h"

@interface ViewController () <UWLocationManagerDelegate>

@property (nonatomic, strong, readwrite) UWLocationManager* locationManager;

@end

@implementation ViewController

- (void)awakeFromNib {
    self.locationManager = [UWLocationManager new];
    self.locationManager.delegate = self;
}

- (void)locationManager:(UWLocationManager*)manager didObtainNewLongitude:(double)lon andLatitude:(double)lat {
    NSLog(@"lat: %f, lon: %f", lat, lon);
    [[UWPizzaPlaceAPI new] pizzaPlaces:lat lon:lon callback:^(double lat, double lon, NSArray * _Nonnull pizzaPlaces) {
        
    }];
}

- (void)locationManager:(UWLocationManager*)manager didObtainError:(NSError*)error {
    [[[UIAlertView alloc] initWithTitle:@"Can not get location" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startLocationService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
