//
//  CLMainViewController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 09.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLMainViewController.h"
#import "CLSelectedIngredientsController.h"
#import "CLActivityIndicator.h"
#import "CLResultRecipesController.h"
#import "CLCookRecipeController.h"
#import "CLCreditsController.h"
#import "CLAppDelegate.h"
#import "CLIngredient.h"
#import "CLIngredientCell.h"
#import "CLDragView.h"
#import "CLSearchBarShadowView.h"
#import "NSOperationQueue+SharedQueue.h"
#import "JSONKit.h"
#import <QuartzCore/QuartzCore.h>

@interface CLMainViewController (Private)

- (void) fetchRecipeCount;
- (NSArray *) selectedIngredients;

- (void)configureCell:(CLIngredientCell *)cell atIndexPath:(NSIndexPath *)indexPath;

// Bar button actions
- (void)showFavorites:(id)sender;
- (void)showCredits:(id)sender;

// If we search or sort our ingredients, we refetch the data from store
- (void)reloadFetchRequest;

// Sort Button Actions
- (IBAction)touchedAlphabetSortButton:(id)sender;
- (IBAction)touchedUsageSortButton:(id)sender;

// Clear Ingredients from Pot view Action
- (IBAction)touchedClearIngredientsButton:(id)sender;

// Show recipes Button Action
- (IBAction)touchedShowRecipesButton:(id)sender;

// Animation if dragging into drop area fails
- (void)returnDragViewToStartPoint:(CLDragView*)dragView;

// Save changes in core data
- (void)saveManagedObjectContext;

// Synchronize ingredients with remote database
- (void)synchronizeIngredients:(NSNotification *)aNotification;

// After (de)selecting a ingredient, update the matched recipes
- (void) updateRecipeCount:(int)count;

// If maximum of ingredients are selected inform the user
- (void)showMaxIngredientsReachedIndicator;

@end

@implementation CLMainViewController

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize potView = _potView;
@synthesize ingredientCell = _ingredientCell;
@synthesize showRecipesButton = _showRecipesButton;
@synthesize removeAllIngredientsButton = _removeAllIngredientsButton;
@synthesize alphabeticalSortButton = _alphabeticalSortButton;
@synthesize usageSortButton = _usageSortButton;

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
  }
  return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  /*UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 44)];
  [titleView setBackgroundColor:[UIColor clearColor]];
  [titleView setShadowColor:[UIColor lightGrayColor]];
  [titleView setTextColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:0.4]];
  [titleView setTextAlignment:UITextAlignmentCenter];
  [titleView setText:@"Cookielicious"];*/
  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_logo.png"]];
  
  self.navigationItem.titleView = titleView;
  
  // Set info button
  UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
  [infoButton addTarget:self 
                 action:@selector(showCredits:) 
       forControlEvents:UIControlEventTouchUpInside];

  self.navigationItem.leftBarButtonItem = 
  [[UIBarButtonItem alloc] initWithCustomView:infoButton];
  
  // Set favorites button
  self.navigationItem.rightBarButtonItem = 
  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ICON_FAVORITES]
                                   style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(showFavorites:)];

  // Show back button for next view controller in navigation controller stack
  UIBarButtonItem *backButton = 
  [[UIBarButtonItem alloc] initWithTitle:@"Zurück" 
                                   style:UIBarButtonItemStylePlain 
                                  target:nil 
                                  action:nil];
  self.navigationItem.backBarButtonItem = backButton;
   
  self.searchBar.delegate = self;
  
  CGRect searchBarShadowViewRect = CGRectMake(-30, 30, 380, 680); //CGRectMake(0, 0, 320, 748)
  CLSearchBarShadowView *view = [[CLSearchBarShadowView alloc] initWithFrame:searchBarShadowViewRect];
  
  [self.view insertSubview:view 
              belowSubview:self.tableView];
  
  // We need to add a small padding to the top of the table in order to avoid a cut scroll indicator by the search bar
  self.tableView.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
  
  // Set background for tab buttons
  UIImage *buttonBackground = [[UIImage imageNamed:@"tab2.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:15];
  
  [_alphabeticalSortButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
  [_usageSortButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
  
  /*[_alphabeticalSortButton setBackgroundImage:[UIImage imageNamed:@"tab1_active.png"]
                                     forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  [_usageSortButton setBackgroundImage:[UIImage imageNamed:@"tab2_active.png"]
                              forState:(UIControlStateHighlighted|UIControlStateSelected)];*/
  
  _selectedIngredientsController = 
  [[CLSelectedIngredientsController alloc] initWithNibName:@"CLSelectedIngredientsController" 
                                                    bundle:nil];
  self.selectedIngredientsController.delegate = self;
  [self.potView addSubview:self.selectedIngredientsController.view];
  
  for (CLIngredient *ingr in self.fetchedResultsController.fetchedObjects) {
    if ([ingr.selected boolValue]) {

      CLDragView *dragView = [[CLDragView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
      
      dragView.delegate = self;
      dragView.label.text = ingr.name;
      dragView.ingredient = ingr;
      [dragView setVisible:YES];
      
      [self.selectedIngredientsController addIngredientWithView:dragView];
    }
  }
  
  [self fetchRecipeCount];
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(synchronizeIngredients:)
                                               name:UIApplicationDidBecomeActiveNotification
                                             object:nil];
}

- (void) viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIApplicationDidBecomeActiveNotification
                                                object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
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
      [tableView reloadData];
      NSLog(@"Insert");
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
  NSLog(@"Controller will change content");
  [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self fetchRecipeCount];
  
  [self.tableView endUpdates];
}

#pragma mark - CLRecipeButtonDelegate

- (void) updateRecipeCount:(int)count {
  if(count < 1) {
    [[self showRecipesButton] setTitle:@"Keine Rezepte" forState:UIControlStateDisabled];
    [[self showRecipesButton] setEnabled:NO];
  }
  else {
    [[self showRecipesButton] setTitle:[NSString stringWithFormat:@"%d Rezept(e)", count] forState:UIControlStateNormal];
    [[self showRecipesButton] setEnabled:YES];
  }
}

#pragma mark - Managed Object Context saving

- (void)saveManagedObjectContext {

  NSError *error = nil;
  if (![__managedObjectContext save:&error]) {
    // Handle the error. 
    NSLog(@"Error saving: %@",error);
  }
}

#pragma mark - CLDragView Delegate

- (void)dragView:(CLDragView *)dragView detectedTapWithRecognizer:(UITapGestureRecognizer *)recognizer {
  
  CLDragView *tappedView = (CLDragView*)[recognizer view];
  
  if (![self.selectedIngredientsController isDragViewLimitReached]) {
    [tappedView setVisible:YES];
    [self.selectedIngredientsController addIngredientWithView:tappedView];
    
  }
  else {
    [self showMaxIngredientsReachedIndicator];
  }
}

- (void)dragView:(CLDragView *)dragView detectedLongPressWithRecognizer:(UILongPressGestureRecognizer *)recognizer {

  CLDragView *draggableView = (CLDragView*)[recognizer view];
  CGPoint touchPoint = [recognizer locationOfTouch:0 inView:self.view];
  CGPoint touchPointWithOffset;
  touchPointWithOffset.x = touchPoint.x - 30;
  touchPointWithOffset.y = touchPoint.y - 30;
  
  switch ([recognizer state]) {
    
    // Dragging begins...
    case UIGestureRecognizerStateBegan:
      NSLog(@"UIGestureRecognizerStateBegan::");
     
      _startingDragPosition = touchPointWithOffset;
      draggableView.center = touchPointWithOffset;
      [self.view addSubview:draggableView];
      [draggableView setVisible:YES];
      [draggableView startDraggingAnimation];
      
      break;
    // Moving finger...drag action
    case UIGestureRecognizerStateChanged:
      NSLog(@"UIGestureRecognizerStateChanged::");
      
      draggableView.center = touchPointWithOffset;
      
      if ((touchPoint.x > self.potView.frame.origin.x) && 
          (touchPoint.y > self.potView.frame.origin.y) &&
          ![self.selectedIngredientsController isDragViewLimitReached])
        [draggableView setShadow:CLShadowGreen];
      else
        [draggableView setShadow:CLShadowRed];
      break;
    // Check if we are in the pot area
    case UIGestureRecognizerStateEnded: {
      NSLog(@"UIGestureRecognizerStateEnded::");

      if ((touchPoint.x > self.potView.frame.origin.x) && 
          (touchPoint.y > self.potView.frame.origin.y) &&
          ![self.selectedIngredientsController isDragViewLimitReached]) {
        
        [self.selectedIngredientsController addIngredientWithView:draggableView];
      }
      else {
        draggableView.ingredient.selected = [NSNumber numberWithBool:NO];
        [self returnDragViewToStartPoint:draggableView];
        if ([self.selectedIngredientsController isDragViewLimitReached]) {
          [self showMaxIngredientsReachedIndicator];
        }
      }
      [draggableView stopDraggingAnimation];
      [self saveManagedObjectContext];
      break;
    }  
    case UIGestureRecognizerStateCancelled:
      NSLog(@"UIGestureRecognizerStateCancelled::");
      draggableView.ingredient.selected = [NSNumber numberWithBool:NO];
      [self returnDragViewToStartPoint:draggableView];
      [draggableView stopDraggingAnimation];
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
  
}

- (void)returnDragViewToStartPoint:(CLDragView*)dragView {
  
  [dragView stopDraggingAnimation];
  [dragView setVisible:NO];
  
  [UIView animateWithDuration:0.4 animations:^{
    
    dragView.center = _startingDragPosition;
  } completion:^(BOOL finished){}];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  [self.searchBar resignFirstResponder];
}

#pragma mark - Action Sort Buttons

- (IBAction)touchedAlphabetSortButton:(id)sender {
  
  // Set button states
  [_alphabeticalSortButton setSelected:YES];
  [_usageSortButton setSelected:NO];
  
  [self.view insertSubview:_alphabeticalSortButton aboveSubview:_usageSortButton];
  
  [self.fetchRequest setSortDescriptors:nil];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" 
                                                                 ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [self.fetchRequest setSortDescriptors:sortDescriptors];
  
  [self reloadFetchRequest];
}

- (IBAction)touchedUsageSortButton:(id)sender {
  
  // Set button states
  [_alphabeticalSortButton setSelected:NO];
  [_usageSortButton setSelected:YES];
  
  [self.view insertSubview:_usageSortButton aboveSubview:_alphabeticalSortButton];
  
  [self.fetchRequest setSortDescriptors:nil];
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"searchCount" 
                                                                 ascending:NO];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  [self.fetchRequest setSortDescriptors:sortDescriptors];
  
  [self reloadFetchRequest];
}

#pragma mark - Show results Buttons

- (IBAction)touchedShowRecipesButton:(id)sender {
  
  NSArray *ingredients = [self.selectedIngredientsController selectedIngredients];
  
  for (CLIngredient *ingr in ingredients) {
    ingr.searchCount = [NSNumber numberWithInt:([ingr.searchCount intValue]+1)];
  }
  [self saveManagedObjectContext];
  
  CLResultRecipesController *resultRecipesController = 
  [[CLResultRecipesController alloc] initWithIngredients:
   [self.selectedIngredientsController selectedIngredients]];
    
  [self.navigationController pushViewController:resultRecipesController animated:YES];
}

#pragma mark - Clear Ingredients Button

- (IBAction)touchedClearIngredientsButton:(id)sender {

  [self.selectedIngredientsController removeAllIngredients];
}

#pragma mark - Selected Ingredients Delegate


- (void)selectedIngredientsController:(CLSelectedIngredientsController *)controller didRemoveAllIngredients:(NSMutableArray *)ingredients {

  for (CLIngredient *ingr in ingredients) {
    ingr.selected = [NSNumber numberWithBool:NO];
  }
  [self saveManagedObjectContext];
}

- (void)selectedIngredientsController:(CLSelectedIngredientsController *)controller didRemoveIngredient:(CLIngredient *)ingredient {

  ingredient.selected = [NSNumber numberWithBool:NO];
  [self saveManagedObjectContext];
}

- (void)selectedIngredientsController:(CLSelectedIngredientsController*)controller didAddIngredient:(CLIngredient*)ingredient {

  ingredient.selected = [NSNumber numberWithBool:YES];
  [self saveManagedObjectContext];
}

#pragma mark - CLFavoriteDelegate

- (void)favoritesController:(CLFavoritesController *)controller didSelectFavoriteWithRecipe:(CLRecipe *)recipe {

  [_favoritesPopoverController dismissPopoverAnimated:YES];
  _favoritesPopoverController = nil;
  CLCookRecipeController *crc = [[CLCookRecipeController alloc] initWithRecipe:recipe];
  [self.navigationController pushViewController:crc animated:YES];
}

#pragma mark - Bar buttons actions

- (void)showCredits:(id)sender {
  
  if (_favoritesPopoverController) {
    [_favoritesPopoverController dismissPopoverAnimated:YES];
    _favoritesPopoverController = nil;
  }

  CLCreditsController *cc = [[CLCreditsController alloc] initWithNibName:@"CLCreditsController" 
                                                                  bundle:nil];
  [cc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
  [cc setModalPresentationStyle:UIModalPresentationCurrentContext];
  [self.navigationController presentModalViewController:cc animated:YES];
  
}

- (void)showFavorites:(id)sender {
  
  if (_favoritesPopoverController) {
    [_favoritesPopoverController dismissPopoverAnimated:YES];
    _favoritesPopoverController = nil;
    return;
  }

  UIPopoverController *popover = 
  [[UIPopoverController alloc] initWithContentViewController:[CLFavoritesController shared]];
  _favoritesPopoverController = popover;
  _favoritesPopoverController.delegate = self;
  [CLFavoritesController shared].delegate = self;
  
  [_favoritesPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem 
                                      permittedArrowDirections:UIPopoverArrowDirectionAny 
                                                      animated:YES];
}

#pragma mark - Popover Delegate

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
  _favoritesPopoverController = nil;
}

#pragma mark - Private

- (void) fetchRecipeCount {
  NSArray *ingredients = [self.selectedIngredientsController selectedIngredients];;
  
  // Show the reset button only if ingredients are availble
  if([ingredients count] < 1) {
    [[self removeAllIngredientsButton] setHidden:YES];
  }
  else {
    [[self removeAllIngredientsButton] setHidden:NO];
  }
  
  // Build get parameters
  NSMutableString *parameters = [[NSMutableString alloc] init];
  for(int i = 0, j = [ingredients count]; i < j; i++) {
    CLIngredient *ingr = (CLIngredient *)[ingredients objectAtIndex:i];
    if(i == 0) {
      [parameters appendFormat:@"ingredients[]=%@",[[ingr name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
      [parameters appendFormat:@"&ingredients[]=%@",[[ingr name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
  }
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/recipes/count?%@",CL_API_URL,parameters]];
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  __unsafe_unretained __block ASIHTTPRequest *blockRequest = request;
  
  [request setRequestHeaders:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObject:@"XMLHttpRequest"]
                                                                forKeys:[NSArray arrayWithObject:@"X-Requested-With"]]];
  
  [request setCompletionBlock:^{
    NSLog(@"Recipe count request finished");
    
    NSDictionary *response = (NSDictionary *)[[blockRequest responseString] objectFromJSONString];
    [self updateRecipeCount:[[response objectForKey:@"count"] intValue]];
  }];
  
  [request setFailedBlock:^{
    NSLog(@"fetchRecipeCount error: %@", [[blockRequest error] localizedDescription]);
  }];
  
  [[NSOperationQueue sharedOperationQueue] cancelAllOperations];
  [[NSOperationQueue sharedOperationQueue] addOperation:request];
}

- (void)synchronizeIngredients:(NSNotification *)aNotification {
  if([(CLAppDelegate *)[[UIApplication sharedApplication] delegate] didSynchronizeIngredients] == YES) {
    return;
  }
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/ingredients",CL_API_URL]];
  
  /*
   In order to prevent xcode from throwing a retain cycle warning, we need to create
   a second __unsafe_unretained __block variable to be used within the block.
  */
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  __unsafe_unretained __block ASIHTTPRequest *blockRequest = request;

  [request setRequestHeaders:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObject:@"XMLHttpRequest"]
                                                                forKeys:[NSArray arrayWithObject:@"X-Requested-With"]]];

  [request setCompletionBlock:^{    
    // Select all existing ingredients
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Ingredient" inManagedObjectContext:[self managedObjectContext]];
    
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES]]];
    
    NSError *error = nil;
    NSArray *currIngredients = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    // Now handle the received data and add it to core data
    NSArray *ingredients = [[blockRequest responseString] objectFromJSONString];
    
    for(NSDictionary *ingrDict in ingredients) {
      NSNumber *identifier = [NSNumber numberWithDouble:[[ingrDict objectForKey:CL_API_JSON_IDKEY] doubleValue]];
      NSString *name = [ingrDict objectForKey:CL_API_JSON_NAMEKEY];
      
      bool create = YES;
      for(CLIngredient *currIngr in currIngredients) {
        if([identifier isEqualToNumber:[currIngr identifier]]) {
          create = NO;
          break;
        }
      }
      
      if (create) {
        CLIngredient *ingr = (CLIngredient *)[NSEntityDescription insertNewObjectForEntityForName:@"Ingredient"
                                                                           inManagedObjectContext:[self managedObjectContext]];
        ingr.identifier = identifier;
        ingr.name = name;
        ingr.searchCount = [NSNumber numberWithInt:0];
      }
    }
    
    [[self managedObjectContext] save:&error];
    if (error != nil) {
      NSLog(@"Error saving data");
    }
    
    [(CLAppDelegate *)[[UIApplication sharedApplication] delegate] setDidSynchronizeIngredients:YES];
    
    NSLog(@"Finished updating ingredients");
  }];
  
  [request setFailedBlock:^{
    NSLog(@"synchronizeIngredients error: %@", [[blockRequest error] localizedDescription]);
  }];
  
  [request startAsynchronous];
}

- (void)showMaxIngredientsReachedIndicator {

  CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
  [activityIndicator setCenterView:nil];
  [activityIndicator setSubMessage:@"Maximum erreicht"];
  
  [activityIndicator show];
  [activityIndicator hideAfterDelay:2];
}

@end
