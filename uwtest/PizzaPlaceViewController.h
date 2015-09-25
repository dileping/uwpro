//
//  PizzaPlaceViewController.h
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PizzaPlace.h"

@interface PizzaPlaceViewController : UIViewController

@property (nonatomic, strong, readwrite) PizzaPlace* pizzaPlace;
@property (nonatomic, weak, readwrite) IBOutlet MKMapView* map;

@end
