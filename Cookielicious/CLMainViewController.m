//
//  CLMainViewController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 09.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLMainViewController.h"
#import "CLSelectedIngredientsController.h"
#import "CLAppDelegate.h"
#import "CLIngredient.h"
#import "CLIngredientCell.h"
#import "CLDragView.h"
#import <QuartzCore/QuartzCore.h>

@interface CLMainViewController (Private)

- (void)configureCell:(CLIngredientCell *)cell atIndexPath:(NSIndexPath *)indexPath;

// If we search or sort our ingredients, we refetch the data from store
- (void)reloadFetchRequest;

// Sort Button Actions
- (IBAction)touchedAlphabetSortButton:(id)sender;
- (IBAction)touchedUsageSortButton:(id)sender;

@end

@implementation CLMainViewController

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize potView = _potView;
@synthesize ingredientCell = _ingredientCell;

@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchRequest = _fetchRequest;

@synthesize selectedIngredientsController = _selectedIngredientsController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

  self = [super initWithCoder:aDecoder];
  if (self) {
    if (__managedObjectContext == nil) { 
      __managedObjectContext = 
      [(CLAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }
//    int i = 0;
//    NSArray *array = [NSArray arrayWithObjects:@"Mehl", @"Salz", @"Tomaten", @"Zwieblen", @"Zucker", @"Wurst", @"Bier", 
//                      @"Fleisch", @"Apfel", @"Birne", @"Brokkoli", @"Blumenkohl", @"Kartoffel", @"Paprika", @"Milch"
//                      , @"Cola", @"Snickers", @"Mate", @"Sekt", @"Rum", @"Hack", 
//                      @"Rahm", @"Zimt", @"Schokolade", @"Meerrettich", @"Filet", nil];
//    
//    for (NSString *str in array) {
//      CLIngredient *newIngredient =
//      (CLIngredient*)[NSEntityDescription 
//                      insertNewObjectForEntityForName:@"Ingredient" 
//                      inManagedObjectContext:__managedObjectContext];
//      
//      
//      newIngredient.identifier = [NSNumber numberWithInt:i];
//      newIngredient.name = str;
//      newIngredient.selected = [NSNumber numberWithBool:NO];
//      
//      NSError *error = nil;
//      
//      if (![__managedObjectContext save:&error]) {
//        // Handle the error. 
//        NSLog(@"Error saving: %@",error);
//      }
//      i++;
//    }
 
  }
  return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.searchBar.delegate = self;
  
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 748)];
  view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern_wood.png"]];
  [self.view insertSubview:view 
              belowSubview:self.searchBar];
  
  view.layer.shadowColor = [[UIColor blackColor] CGColor];
  view.layer.shadowOffset = CGSizeMake(2.0, 0.0);
  view.layer.shadowRadius = 5.0;
  view.layer.shadowOpacity = 0.5;
  view.layer.masksToBounds = NO;
  view.layer.shouldRasterize = YES;
  
  _selectedIngredientsController = 
  [[CLSelectedIngredientsController alloc] initWithNibName:@"CLSelectedIngredientsController" 
                                                    bundle:nil];
  [self.potView addSubview:self.selectedIngredientsController.view];
  
  for (CLIngredient *ingr in self.fetchedResultsController.fetchedObjects) {
    if ([ingr.selected boolValue]) {

      CLDragView *dragView;
      NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLDragView" 
                                                       owner:self 
                                                     options:nil];
      
      for (NSObject *obj in objects) {
        if ([obj isKindOfClass:NSClassFromString(@"CLDragView")]) {
          dragView = (CLDragView*)obj;
        }
      }
      
      dragView.delegate = self;
      dragView.label.text = ingr.name;
      dragView.ingredient = ingr;
      [dragView setVisible:YES];
      
      [self.selectedIngredientsController addIngredientWithView:dragView];
    }
  }

}

- (void)viewDidUnload {
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? YES : NO;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"IngredientCell";
  
  CLIngredientCell *cell = 
  (CLIngredientCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    
    [[NSBundle mainBundle] loadNibNamed:@"CLIngredientCell" 
                                  owner:self 
                                options:nil];
  
    cell = self.ingredientCell;
    
  }
  
  // Configure the cell.

  
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(CLIngredientCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  
  CLIngredient *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.ingredient = managedObject;
  
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
  [self.tableView reloadData];
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
      [self configureCell:(CLIngredientCell*)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
      break;
      
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  
  [self.tableView endUpdates];
}

#pragma mark - CLDragView Delegate

- (void)detectedLongPressWithRecognizer:(UILongPressGestureRecognizer*)recognizer {

  CLDragView *draggableView = (CLDragView*)[recognizer view];
  CGPoint touchPoint = [recognizer locationOfTouch:0 inView:self.view];
  
  switch ([recognizer state]) {
    
    // Dragging begins...
    case UIGestureRecognizerStateBegan:
      NSLog(@"UIGestureRecognizerStateBegan::");
     
      _startingDragPosition = touchPoint;
      draggableView.center = touchPoint;
      [self.view addSubview:draggableView];
      [draggableView setVisible:YES];
      [draggableView scaleUp];
      
      break;
    // Moving finger...drag action
    case UIGestureRecognizerStateChanged:
      NSLog(@"UIGestureRecognizerStateChanged::");
      
      draggableView.center = touchPoint;

      break;
    // Check if we are in the pot area
    case UIGestureRecognizerStateEnded: {
      NSLog(@"UIGestureRecognizerStateEnded::");

      if ((touchPoint.x > self.potView.frame.origin.x) && 
          (touchPoint.y > self.potView.frame.origin.y)) {
        
        BOOL success = [self.selectedIngredientsController addIngredientWithView:draggableView];
 
        if (success) {
          draggableView.ingredient.selected = [NSNumber numberWithBool:YES];
          [draggableView scaleDown];
        }
        else {
          draggableView.ingredient.selected = [NSNumber numberWithBool:NO];
          [draggableView setVisible:NO];
          [UIView animateWithDuration:0.4 animations:^{
            
            draggableView.center = _startingDragPosition;
          } completion:^(BOOL finished){}];
        }
      }
      else {
        draggableView.ingredient.selected = [NSNumber numberWithBool:NO];
        [draggableView setVisible:NO];
        [UIView animateWithDuration:0.4 animations:^{
          
          draggableView.center = _startingDragPosition;
        } completion:^(BOOL finished){}];
      }
      NSError *error = nil;
      if (![__managedObjectContext save:&error]) {
        // Handle the error. 
        NSLog(@"Error saving: %@",error);
      }
      break;
    }  
    case UIGestureRecognizerStateCancelled:
      NSLog(@"UIGestureRecognizerStateCancelled::");
      break;
      
    case UIGestureRecognizerStateFailed:
      NSLog(@"UIGestureRecognizerStateFailed::");
      break;
      
    default:
      break;
  }
}

- (void)removeDragView:(CLDragView*)dragView withIngredient:(CLIngredient*)ingredient {

  [_selectedIngredientsController removeIngredientWithView:dragView];
  
  ingredient.selected = [NSNumber numberWithBool:NO];
  
  NSError *error = nil;
  if (![__managedObjectContext save:&error]) {
    // Handle the error. 
    NSLog(@"Error saving: %@",error);
  }
}

#pragma mark - CLSearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

  NSLog(@"%@", searchBar.text);
  
  if (searchText != nil && ![searchText isEqualToString:@""]) {
    NSPredicate *predicate = 
    [NSPredicate predicateWithFormat:@"name beginswith[c] %@", searchText];
    [self.fetchRequest setPredicate:predicate];
  }
  else {
    [self.fetchRequest setPredicate:nil];
  }
  [self reloadFetchRequest];

}

#pragma mark - Action Sort Buttons

- (IBAction)touchedAlphabetSortButton:(id)sender {
  
  [self.fetchRequest setSortDescriptors:nil];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" 
                                                                 ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [self.fetchRequest setSortDescriptors:sortDescriptors];
  
  [self reloadFetchRequest];
}

- (IBAction)touchedUsageSortButton:(id)sender {
  
  [self.fetchRequest setSortDescriptors:nil];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" 
                                                                 ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [self.fetchRequest setSortDescriptors:sortDescriptors];
  
  [self reloadFetchRequest];
  
}

@end
