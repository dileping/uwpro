//
//  PizzaPlace+Gateway.m
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import "PizzaPlace+Gateway.h"
#import "AppDelegate.h"

@implementation PizzaPlace (Gateway)

-(NSArray*) pizzaPlacesForLat:(double) lat lon:(double)lon {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"PizzaPlace"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"lat >= (%lf-0.01) AND lat <= (%lf+0.01) AND lon >= (%lf-0.01) AND lon >= (%lf+0.01)", lat, lat, lon, lon];
    [request setPredicate:predicate];
    NSError* error = nil;
    NSArray* results = [delegate.managedObjectContext executeFetchRequest:request error:&error];
    if(error) {
        NSLog(@"Can not fetch pizza: %@", error);
    }
    return results;
}

+(PizzaPlace*) pizzaPlaceWith:(NSString*)id name:(NSString*)name lat:(double)lat lon:(double)lon {
    AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
    __block PizzaPlace* pizzaPlace = nil;
    [delegate.backgroundObjectContext performBlockAndWait:^() {
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"PizzaPlace"];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"id == %@", id];
        [request setPredicate:predicate];
        NSError* error = nil;
        NSArray* results = [delegate.backgroundObjectContext executeFetchRequest:request error:&error];
        if (error || [results count] > 1) {
            return;
        }
        if ([results count] > 0) {
            pizzaPlace = [results lastObject];
        } else {
            pizzaPlace = [NSEntityDescription insertNewObjectForEntityForName:@"PizzaPlace" inManagedObjectContext:delegate.backgroundObjectContext];
            pizzaPlace.id = id;
        }
        pizzaPlace.name = name;
        pizzaPlace.lat = lat;
        pizzaPlace.lon = lon;
    }];
    
    return pizzaPlace;
}

@end
