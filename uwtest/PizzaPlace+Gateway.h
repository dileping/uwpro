//
//  PizzaPlace+Gateway.h
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import "PizzaPlace.h"

@interface PizzaPlace (Gateway)

-(NSArray*) pizzaPlacesForLat:(double) lat lon:(double)lon;
+(PizzaPlace*) pizzaPlaceWith:(NSString*)id name:(NSString*)name lat:(double)lat lon:(double)lon;

@end
