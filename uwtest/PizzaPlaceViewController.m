//
//  PizzaPlaceViewController.m
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import "PizzaPlaceViewController.h"

@implementation PizzaPlaceViewController

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    CLLocationCoordinate2D coord = {.latitude =  self.pizzaPlace.lat, .longitude =  self.pizzaPlace.lon};
    MKCoordinateSpan span = {.latitudeDelta =  0.02, .longitudeDelta =  0.02};
    MKCoordinateRegion region = {coord, span};
    [self.map setRegion:region];
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    [annotation setCoordinate:coord];
    [annotation setTitle:self.pizzaPlace.name];
    [self.map addAnnotation:annotation];
}

-(void) viewDidAppear:(BOOL)animated {
    [self.map selectAnnotation:[self.map.annotations lastObject] animated:YES];
}

@end
