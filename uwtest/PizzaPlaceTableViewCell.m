//
//  PizzaPlaceTableViewCell.m
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//

#import "PizzaPlaceTableViewCell.h"

@implementation PizzaPlaceTableViewCell

-(void) refresh {
    self.label.text = _pizzaPlace.name;
}

-(void) setPizzaPlace:(PizzaPlace *)pizzaPlace {
    BOOL isNew = _pizzaPlace != pizzaPlace;
    _pizzaPlace = pizzaPlace;
    if(isNew) {
        [self refresh];
    }
}

@end
