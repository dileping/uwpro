//
//  PizzaPlace+CoreDataProperties.h
//  uwtest
//
//  Created by Daniel Leping on 9/25/15.
//  Copyright © 2015 Crossroad Labs, LTD. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PizzaPlace.h"

NS_ASSUME_NONNULL_BEGIN

@interface PizzaPlace (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *id;
@property (nonatomic) double lat;
@property (nonatomic) double lon;

@end

NS_ASSUME_NONNULL_END
