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
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@interface CLResultRecipesController (Private)

- (void) requestRecipes:(NSArray *)ingredients;

// Maybe put animations in separate member
@end

@implementation CLResultRecipesController

@synthesize recipeGridView = _recipeGridView;
@synthesize recipeDetailView = _recipeDetailView;
@synthesize flipView = _flipView;
@synthesize shadowView = _shadowView;

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

#pragma mark - Private members

- (void) requestRecipes:(NSArray *)ingredients {
  // Build get parameters
  NSMutableString *parameters = [[NSMutableString alloc] init];
  for(int i = 0, j = [ingredients count]; i < j; i++) {
    CLIngredient *ingr = (CLIngredient *)[ingredients objectAtIndex:i];
    if(i == 0) {
      [parameters appendFormat:@"ingredients[]=%@",[ingr name]];
    }
    else {
      [parameters appendFormat:@"&ingredients[]=%@",[ingr name]];
    }
  }
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/recipes?%@",CL_API_URL,parameters]];
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  
  NSLog(@"%@", parameters);
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
    
    // Set the delegate for the shadow view
    _shadowView.delegate = self;
    
    // Load the recipe detail view
    NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLRecipeDetailView" 
                                                     owner:self 
                                                   options:nil];
    for(NSObject *obj in objects) {
        if([obj isKindOfClass:NSClassFromString(@"CLRecipeDetailView")]) {
            _recipeDetailView = (CLRecipeDetailView *)obj;
        }
    }
    
    // We want the recipe detail view to be in the center of the result view
    _recipeDetailView.center = CGPointMake(_recipeGridView.bounds.size.width/2, _recipeGridView.bounds.size.height/2);
    
    // 26px -- ||200px|| -- 26px -- ||200px|| -- 26px -- ||200px|| -- 26px
    int cols = 3;
    int rows = ceil((float)[array count] / (float)cols);
    
    _recipeGridView.contentSize = CGSizeMake(
        26*2 + 26 * (cols - 1) + 200 * cols,
        26*2 + 26 * (rows - 1) + 200 * rows
    );
    
    for (int i = 0, j = [array count]; i < j; i++) {
        CLIngredient *ingr = (CLIngredient *)[array objectAtIndex:i];
        
        NSLog(@"%@", ingr.name);
        
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLRecipeView" 
                                                         owner:self 
                                                       options:nil];
        CLRecipeView *recipeView;
        for(NSObject *obj in objects) {
            if([obj isKindOfClass:NSClassFromString(@"CLRecipeView")]) {
                recipeView = (CLRecipeView *)obj;
            }
        }
        
        // Position the view in the griiiid! hell yeah
        int col = i%3;
        int row = i/3; // integer division
        
        int x = 26 * (col + 1) + 200 * col + 100;
        int y = 26 * (row + 1) + 200 * row + 100;
        
        recipeView.center = CGPointMake(x, y);
        recipeView.delegate = self;
        
        // Initialization code
        
        [recipeView.titleLabel setText:[ingr name]];        
        [_recipeGridView addSubview:recipeView];
    }
  
  [self requestRecipes:array];
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

#pragma mark - CLRecipeDetailViewDelegate

- (void) showRecipeDetailView:(NSObject *)recipeVal forView:(CLRecipeView *)viewVal {      
    CGPoint flipViewCenterPoint = CGPointMake(_flipView.bounds.size.width/2, _flipView.bounds.size.height/2);
    CGPoint recipeGridViewCenterPoint = CGPointMake(_recipeGridView.bounds.size.width/2, _recipeGridView.bounds.size.height/2 + _recipeGridView.contentOffset.y);
    
    [_recipeGridView addSubview:_shadowView];
    [_recipeGridView addSubview:_flipView];
    
    // Save the current center point of the recipe in order to flip it back
    currRecipeView = viewVal;
    currRecipeCenterPoint = viewVal.center;
    
    // We need to set the flip views center to the center point of the current recipe.
    // After we have done that, we need to reposition the current recipe view in the flip view,
    // the same goes for the recipe detail view.
    // If we skip this step, the flip animation would result in some weird transition.
    _flipView.center = viewVal.center;
    viewVal.center = flipViewCenterPoint;
    _recipeDetailView.center = flipViewCenterPoint;
    
    _shadowView.center = recipeGridViewCenterPoint;
    
    // Position flip and shadow views in front of all recipe views
    [_recipeGridView bringSubviewToFront:_shadowView];
    [_recipeGridView bringSubviewToFront:_flipView];
    
    // Stop scrolling in recipe grid
    [_recipeGridView setScrollEnabled:NO];
    
    [UIView animateWithDuration:0
                     animations:^{
                         [_flipView addSubview:viewVal];
                     }
                     completion:^(BOOL finished) {
                         [UIView transitionWithView:_flipView
                                           duration:0.3
                                            options:UIViewAnimationOptionTransitionFlipFromLeft
                                         animations:^ {
                                             _flipView.center = recipeGridViewCenterPoint;
                                             
                                             [_shadowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
                                             
                                             [viewVal removeFromSuperview];
                                             [_flipView addSubview:_recipeDetailView];
                                         }
                                         completion:^(BOOL finished) {
                                         }];
                     }];
}

- (void) hideRecipeDetailView {
    [UIView transitionWithView:_flipView
                      duration:0.3
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^ {
                        _flipView.center = currRecipeCenterPoint;
                        
                        [_shadowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
                        
                        [_recipeDetailView removeFromSuperview];
                        [_flipView addSubview:currRecipeView];
                    }
                    completion:^(BOOL finished) {
                        [currRecipeView removeFromSuperview];
                        currRecipeView.center = currRecipeCenterPoint;
                        [_recipeGridView addSubview:currRecipeView];
                        
                        [_shadowView removeFromSuperview];
                        [_flipView removeFromSuperview];
                        
                        
                        // Reenable scrolling
                        [_recipeGridView setScrollEnabled:YES];
                    }];
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
