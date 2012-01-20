//
//  CLFavoritesController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 16.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLFavoritesController.h"
#import "CLCookRecipeController.h"
#import "CLFavoriteCell.h"
#import "CLRecipe.h"
#import "CLFavorite.h"
#import "CLAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "NSOperationQueue+SharedQueue.h"

@interface CLFavoritesController (Private)

- (NSFetchRequest*)fetchRequestForRecipe:(CLRecipe*)recipe;
- (void)saveManagedObjectContext;
- (void)showViewForEmptyTableView:(BOOL)show;

@end

@implementation CLFavoritesController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize delegate = _delegate;

+ (CLFavoritesController*)shared {
  static dispatch_once_t pred;
  static CLFavoritesController *fc = nil;
  
  dispatch_once(&pred, ^{ 
    fc = [[self alloc] initWithStyle:UITableViewStylePlain]; 
  });
  return fc;
}

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    if (_managedObjectContext == nil) { 
      _managedObjectContext = 
      [(CLAppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext]; 
    }  
  }
  return self;
}

- (CGSize)contentSizeForViewInPopover {
  
  return CGSizeMake(320, 400);
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];

  if ([sectionInfo numberOfObjects] <= 0) 
    [self showViewForEmptyTableView:YES];
  else
    [self showViewForEmptyTableView:NO];
  
  return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"FavoriteCell";
  
  CLFavoriteCell *cell = (CLFavoriteCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLFavoriteCell" 
                                                     owner:self 
                                                   options:nil];
    
    for (NSObject *obj in objects) {
      if ([obj isKindOfClass:NSClassFromString(@"CLFavoriteCell")]) {
        cell = (CLFavoriteCell*)obj;
      }
    }
  }
  
  // Configure the cell...
  CLFavorite *managedObject = (CLFavorite*)[self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.titleLabel.text = managedObject.title;
  cell.dateLabel.text = 
  [NSString stringWithFormat:@"Hinzugefügt am: %@", 
   [managedObject formattedDate]];
  [cell.previewImage setImage:managedObject.previewImage];
  
  return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    // Delete the row from the data source
    CLFavorite *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [_managedObjectContext deleteObject:managedObject];
    
    [self saveManagedObjectContext];
  }      
}


#pragma mark - Table view delegate

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  return 66.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  CLFavorite *managedObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/recipe/%d",CL_API_URL, [managedObject.identifier intValue]]];
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  __unsafe_unretained __block ASIHTTPRequest *blockRequest = request;
  
  [request setRequestHeaders:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObject:@"XMLHttpRequest"]
                                                                forKeys:[NSArray arrayWithObject:@"X-Requested-With"]]];
  
  [request setCompletionBlock:^{
    NSLog(@"Favorite recipe successful loaded from server");
    NSDictionary *response = (NSDictionary *)[[blockRequest responseString] objectFromJSONString];
    NSLog(@"%@", [blockRequest responseString]);
    CLRecipe *recipe = [[CLRecipe alloc] initWithDictionary:response];
    
    if (_delegate && [_delegate respondsToSelector:@selector(favoritesController:didSelectFavoriteWithRecipe:)]) {
      [_delegate performSelector:@selector(favoritesController:didSelectFavoriteWithRecipe:) 
                      withObject:self 
                      withObject:recipe];
    }
  }];
  
  [request setFailedBlock:^{
    NSLog(@"Favorite recipe request failed");
  }];
  
  [[NSOperationQueue sharedOperationQueue] addOperation:request];

}


#pragma mark - NSFetchedResultControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
  
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
  
  [NSFetchedResultsController deleteCacheWithName:@"Favorites"];
  _fetchedResultsController = nil;
  // Set up the fetched results controller.
  // Create the fetch request for the entity.
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" 
                                            inManagedObjectContext:_managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size to a suitable number.
  
  [fetchRequest setFetchBatchSize:20];
  
  // Edit the sort key as appropriate.
  
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"identifier" 
                                                                 ascending:YES];
  NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  
  NSFetchedResultsController *aFetchedResultsController = 
  [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                      managedObjectContext:_managedObjectContext 
                                        sectionNameKeyPath:nil 
                                                 cacheName:@"Favorites"];
  aFetchedResultsController.delegate = self;
  _fetchedResultsController = aFetchedResultsController;
  
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
  
  return _fetchedResultsController;
}

- (void)reloadFetchRequest {
  
  [NSFetchedResultsController deleteCacheWithName:@"Favorites"];
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
      [self.tableView reloadData];
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
  
  [self.tableView endUpdates];
}

#pragma mark - Actions

- (void)addFavoriteWithRecipe:(CLRecipe *)recipe {
  
  if (![self isRecipeFavorite:recipe]) {
    
    CLFavorite *favorite = (CLFavorite *)[NSEntityDescription insertNewObjectForEntityForName:@"Favorite"
                                                                       inManagedObjectContext:_managedObjectContext];
    // Set id and title
    favorite.identifier = [NSNumber numberWithInt:recipe.identifier];
    favorite.title = recipe.title;
    
    // Set current date
    NSDate *now = [NSDate date];
    favorite.date = now;
    
    // Retrieve preview image to store it in core data
    NSURL *url = [[NSURL alloc] initWithString:recipe.image];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    __unsafe_unretained __block ASIHTTPRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
      // Set the retrieved image
      UIImage *theImage = [[UIImage alloc] initWithData:[blockRequest responseData]];
      favorite.previewImage = theImage;
      [self saveManagedObjectContext];
      _requestIsPerforming = NO;
      [[NSNotificationCenter defaultCenter] postNotificationName:CL_NOTIFY_FAVORITE_ADDED 
                                                          object:self];

    }];
    [request setFailedBlock:^{
      // Add to core data without image
      [self saveManagedObjectContext];
      _requestIsPerforming = NO;
    }];

    [[NSOperationQueue sharedOperationQueue] addOperation:request];
    _requestIsPerforming = YES;
  }
}

- (void)removeFavoriteWithRecipe:(CLRecipe *)recipe {
  
  if (_requestIsPerforming) {
    return;
  }
  if ([self isRecipeFavorite:recipe]) {
    
    NSFetchRequest *fetchRequest = [self fetchRequestForRecipe:recipe];
    
    NSError *error = nil;
    NSArray *result = [_managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error != nil) {
      NSLog(@"Error fetching entities");
    }
    
    if([result count] < 1) {
      return;
    }
    
    NSLog(@"%d", [result count]);
    
    [_managedObjectContext deleteObject:[result objectAtIndex:0]];
    
    [self saveManagedObjectContext];
  }
}

- (BOOL)isRecipeFavorite:(CLRecipe *)recipe {
  
  NSFetchRequest *fetchRequest = [self fetchRequestForRecipe:recipe];
  
  NSError *error = nil;
  NSUInteger count = [_managedObjectContext countForFetchRequest:fetchRequest 
                                                           error:&error];
  
  if (!error){
    return (count >= 1) ? YES : NO;
  }
  return -1;
}

#pragma mark - Private

- (NSFetchRequest*)fetchRequestForRecipe:(CLRecipe *)recipe {
  
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Favorite" 
                                            inManagedObjectContext:_managedObjectContext];
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  [fetchRequest setEntity:entity];
  
  NSPredicate *predicate = 
  [NSPredicate predicateWithFormat:@"identifier = %d", recipe.identifier];
  [fetchRequest setPredicate:predicate];
  
  return fetchRequest;
  
}

- (void)saveManagedObjectContext {
  
  NSError *error = nil;
  [_managedObjectContext save:&error];
  if (error != nil) {
    NSLog(@"Error saving data");
  }
}

- (void)showViewForEmptyTableView:(BOOL)show {
  
  if (show) {
    if (!_emptyView) {
      NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLEmptyView" 
                                                       owner:self 
                                                     options:nil];
      
      for (NSObject *obj in objects) {
        if ([obj isKindOfClass:NSClassFromString(@"UIView")]) {
          _emptyView = (UIView*)obj;
        }
      }
      [self.tableView addSubview:_emptyView];
      [self.tableView setUserInteractionEnabled:NO];
    }
  }
  else {
    [_emptyView removeFromSuperview];
    _emptyView = nil;
    [self.tableView setUserInteractionEnabled:YES]; 
  }
}

@end
