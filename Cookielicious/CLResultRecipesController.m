//
//  CLResultRecipesController.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLAppDelegate.h"
#import "CLResultRecipesController.h"
#import "CLIngredient.h"

@implementation CLResultRecipesController

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchRequest = _fetchRequest;

#pragma mark - Object initialization


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        if (__managedObjectContext == nil) { 
            __managedObjectContext = 
            [(CLAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (__managedObjectContext == nil) { 
            __managedObjectContext = 
            [(CLAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
        }
    }
    return self;
}

#pragma mark - Memory warnings

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Ingredient" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = %f", 1.0];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *array = [[self managedObjectContext] executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Failed fetching selected ingredients");
        exit(-1);
    }

    for (CLIngredient *ingr in array) {
        NSLog(@"%@", ingr.name);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - NSFetchedResultControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (__fetchedResultsController != nil) {
        return __fetchedResultsController;
    }
    
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    __fetchedResultsController = nil;
    // Set up the fetched results controller.
    // Create the fetch request for the entity.
    
    _fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Ingredient" 
                                              inManagedObjectContext:self.managedObjectContext];
    [self.fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    
    [self.fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" 
                                                                   ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    [self.fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    
    NSFetchedResultsController *aFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:self.fetchRequest 
                                        managedObjectContext:self.managedObjectContext 
                                          sectionNameKeyPath:nil 
                                                   cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. 
         You should not use this function in a shipping application, although it may 
         be useful during development. 
         */
        
        NSLog(@"fetchedResultsController::Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
    
    return __fetchedResultsController;
}

- (void)reloadFetchRequest {
    
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         abort() causes the application to generate a crash log and terminate. 
         You should not use this function in a shipping application, although it may 
         be useful during development. 
         */
        
        NSLog(@"reloadFetchRequest::Unresolved error %@, %@", error, [error userInfo]);
        abort();
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            break;
            
        case NSFetchedResultsChangeDelete:
            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:
            break;
    }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {}


@end
