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
#import "PizzaPlace+Gateway.h"
#import "AppDelegate.h"
#import "PizzaPlaceViewController.h"
#import "PizzaPlaceTableViewCell.h"

@interface ViewController () <UWLocationManagerDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong, readwrite) UWLocationManager* locationManager;
@property (nonatomic, strong, readwrite) UWPizzaPlaceAPI* api;
@property (nonatomic, strong, readwrite) NSFetchedResultsController* fetchedResultsController;

@end

@implementation ViewController

- (void)awakeFromNib {
    [self.tableView registerNib:[UINib nibWithNibName:@"PizzaPlaceTableViewCell" bundle:nil] forCellReuseIdentifier:@"pizzaPlaceCell"];
    
    self.locationManager = [UWLocationManager new];
    self.locationManager.delegate = self;
    self.api = [UWPizzaPlaceAPI new];
    AppDelegate* delegte = [[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshContextWithObjectDidChangeNotification:) name:@"reload" object:delegte];
}

- (void)locationManager:(UWLocationManager*)manager didObtainNewLongitude:(double)lon andLatitude:(double)lat {
    NSLog(@"lat: %f, lon: %f", lat, lon);
    static double const D = 200. * 1.1;
    double const R = 6371009.; // Earth readius in meters
    double meanLatitidue = lat * M_PI / 180.;
    double deltaLatitude = D / R * 180. / M_PI;
    double deltaLongitude = D / (R * cos(meanLatitidue)) * 180. / M_PI;
    double minLatitude = lat - deltaLatitude;
    double maxLatitude = lat + deltaLatitude;
    double minLongitude = lon - deltaLongitude;
    double maxLongitude = lon + deltaLongitude;
    NSPredicate* predicate = [NSPredicate predicateWithFormat:
     @"(%@ <= lon) AND (lon <= %@)"
     @"AND (%@ <= lat) AND (lat <= %@)",
     @(minLongitude), @(maxLongitude), @(minLatitude), @(maxLatitude)];
    

    [self.fetchedResultsController.fetchRequest setPredicate:predicate];
    [self.api pizzaPlaces:lat lon:lon callback:^(double lat, double lon, NSArray * _Nonnull pizzaPlaces) {
        for(id pizzaPlaceResult in pizzaPlaces) {
            id location = pizzaPlaceResult[@"location"];
            [PizzaPlace pizzaPlaceWith:pizzaPlaceResult[@"id"]
                                  name:pizzaPlaceResult[@"name"]
                                   lat:[location[@"lat"] doubleValue]
                                   lon:[location[@"lng"] doubleValue]];
        }
        AppDelegate* delegte = [[UIApplication sharedApplication] delegate];
        [delegte saveToDisk];
    }];
}

- (void)locationManager:(UWLocationManager*)manager didObtainError:(NSError*)error {
//    [[[UIAlertView alloc] initWithTitle:@"Can not get location" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PizzaPlace"];
    [fetchRequest setFetchLimit:5];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    fetchRequest.sortDescriptors = @[descriptor];
    
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    // Setup fetched results
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:[appDelegate managedObjectContext]
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self.fetchedResultsController setDelegate:self];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager startLocationService];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.locationManager stopLocationService];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController.sections count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PizzaPlaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pizzaPlaceCell" forIndexPath:indexPath];
    PizzaPlace* object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.pizzaPlace = object;
    return cell;
}

-(void)refreshContextWithObjectDidChangeNotification:(NSNotification *)notification {
//    dispatch_async(dispatch_get_main_queue(), ^(){
        NSError* error = nil;
        [self.fetchedResultsController performFetch:&error];
        [self.tableView reloadData];
        if(error) {
            NSLog(@"Can not fetch: %@", error);
        }
//    });
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PizzaPlaceViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"PizzaPlaceDetail"];
    PizzaPlace* pizzaPlace = [self.fetchedResultsController objectAtIndexPath:indexPath];
    ctrl.pizzaPlace = pizzaPlace;
    [self.navigationController pushViewController:ctrl animated:YES];
}

@end
