//
//  CLResultRecipesController.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLAppDelegate.h"
#import "CLSearchBarShadowView.h"
#import "CLResultRecipesController.h"
#import "CLIngredient.h"
#import "CLRecipe.h"
#import "CLIngredientCell.h"
#import "CLCookRecipeController.h"
#import "CLActivityIndicator.h"
#import "NSOperationQueue+SharedQueue.h"
#import "JSONKit.h"

@interface CLResultRecipesController (Private)

- (void) requestRecipes;
- (void) displayFilteredRecipes;
- (void) displayRecipes:(NSArray *)recipes;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)setCellState:(UITableViewCell *)cell isSelected:(BOOL)state;
// Maybe put animations in separate member
@end

@implementation CLResultRecipesController

@synthesize recipeGridView = _recipeGridView;
@synthesize recipeDetailView = _recipeDetailView;
@synthesize flipView = _flipView;
@synthesize tableView = _tableView;
@synthesize shadowView = _shadowView;
@synthesize recipes = _recipes;
@synthesize ingredientCell = _ingredientCell;

- (NSMutableArray *) recipes {
  if(_recipes == nil) {
    _recipes = [[NSMutableArray alloc] init];
  }
  
  return _recipes;
}

#pragma mark - Object initialization

- (id) initWithIngredients:(NSArray *)ingredients {
  self = [super initWithNibName:@"CLResultRecipesController" bundle:nil];
  if(self) {
    _selectedIngredients = ingredients;
  }
  return self;
}

#pragma mark - Private members

- (void)setCellState:(UITableViewCell *)cell isSelected:(BOOL)state {
  // Set background view for selected cell
  if(state) {
    UIImageView *_checkmark = 
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ICON_CHECKMARK]];
    
    [cell setAccessoryView:_checkmark];
  }
  else {
    [cell setAccessoryView
     :nil];
  }
}

- (void) requestRecipes {
  // Build get parameters
  NSMutableString *parameters = [[NSMutableString alloc] init];
  for(int i = 0, j = [_selectedIngredients count]; i < j; i++) {
    CLIngredient *ingr = (CLIngredient *)[_selectedIngredients objectAtIndex:i];
    if(i == 0) {
      [parameters appendFormat:@"ingredients[]=%@",[[ingr name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
      [parameters appendFormat:@"&ingredients[]=%@",[[ingr name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
  }
  
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/recipes?%@",CL_API_URL,parameters]];
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  
  [request setRequestHeaders:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObject:@"XMLHttpRequest"]
                                                                forKeys:[NSArray arrayWithObject:@"X-Requested-With"]]];
  
  [request setDelegate:self];
  [request startAsynchronous];
  
  NSLog(@"%@", parameters);
}

- (void) displayFilteredRecipes {
  NSMutableArray *filteredRecipes = [[NSMutableArray alloc] init];
  for(CLRecipe *currRecipe in _recipes) {
    if ([currRecipe containsIngredients:_currSelectedIngredients]) {
      [filteredRecipes addObject:currRecipe];
    }
  }
  
  [self displayRecipes:filteredRecipes];
}

- (void) displayRecipes:(NSArray *)recipes {
  // Clear all network operations
  [[NSOperationQueue sharedOperationQueue] cancelAllOperations];
  
  // Clear grid
  for (UIView *currSubview in [_recipeGridView subviews]) {
    if(currSubview != _shadowView && currSubview != _flipView) {
      [currSubview removeFromSuperview];
    }
  }
  
  /*if([recipes count] < 1) {
    // No recipes to show
    UILabel *noRecipesLabel = [[UILabel alloc] init];
    [noRecipesLabel setText:@"Keine Rezepte"];
    
    noRecipesLabel setFrame:CGRectMake(_recipeGridView.frame.size.width/2, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    [_recipeGridView addSubview:noRecipesLabel];
    
    return;
  }*/
  
  // We want the recipe detail view to be in the center of the result view
  _recipeDetailView.center = CGPointMake(_recipeGridView.bounds.size.width/2, _recipeGridView.bounds.size.height/2);
  
  // 26px -- ||200px|| -- 26px -- ||200px|| -- 26px -- ||200px|| -- 26px
  int cols = 3;
  int rows = ceil((float)[recipes count] / (float)cols);
  
  _recipeGridView.contentSize = CGSizeMake(
                                           26*2 + 26 * (cols - 1) + 200 * cols,
                                           26*2 + 26 * (rows - 1) + 200 * rows
                                           );
  
  for (int i = 0, j = [recipes count]; i < j; i++) {
    CLRecipe *recipe = (CLRecipe *)[recipes objectAtIndex:i];
    
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
    
    // Remove annoying padding on text view
    [recipeView configureView:recipe];
    
    [_recipeGridView addSubview:recipeView];
  }
}

#pragma mark - ASIHTTPRequest Delegate

- (void)requestStarted:(ASIHTTPRequest *)request {
  // Add activity indicator
  [[self view] bringSubviewToFront:_shadowView];
  
  UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  
  CGPoint center = CGPointMake(_shadowView.bounds.size.width/2 - activityIndicator.bounds.size.width/2, _shadowView.bounds.size.height/2 - activityIndicator.bounds.size.height/2);
  
  [activityIndicator setCenter:center];
  [activityIndicator setHidesWhenStopped:NO];
  [activityIndicator startAnimating];
  
  [_shadowView addSubview:activityIndicator];
  
  [_shadowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  NSLog(@"Response body: %@", [request responseString]);
  
  [[self recipes] removeAllObjects];
  for(NSDictionary *recipeDict in [[request responseString] objectFromJSONString]) {
    CLRecipe *recipe = [[CLRecipe alloc] initWithDictionary:recipeDict];
    [_recipes addObject:recipe];
  }
  
  [_shadowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
  for(UIView *subview in [_shadowView subviews]) {
    [subview removeFromSuperview];
  }
  
  [self displayRecipes:_recipes];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  NSLog(@"Requesting recipe failed");
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
  
  // Show back button for next view controller in navigation controller stack
  UIBarButtonItem *backButton = 
  [[UIBarButtonItem alloc] initWithTitle:@"Zurück" 
                                   style:UIBarButtonItemStylePlain 
                                  target:nil 
                                  action:nil];
  self.navigationItem.backBarButtonItem = backButton;
  
  _currSelectedIngredients = [[NSMutableArray alloc] init];
  
  // Set the delegate for the shadow view
  _shadowView.delegate = self;
  [_shadowView setFrame:CGRectMake(-320, 0, 1024, 768)];
  
  // Add background to the table view
  CLSearchBarShadowView *view = [[CLSearchBarShadowView alloc] initWithFrame:CGRectMake(-30, 30, 380, 680)];
  
  [self.view insertSubview:view 
              belowSubview:self.tableView];
  
  // Load the recipe detail view
  NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"CLRecipeDetailView" 
                                                   owner:self 
                                                 options:nil];
  for(NSObject *obj in objects) {
    if([obj isKindOfClass:NSClassFromString(@"CLRecipeDetailView")]) {
      _recipeDetailView = (CLRecipeDetailView *)obj;
      // Set detail view delegate
      _recipeDetailView.delegate = self;
    }
  }
  
  [_recipeDetailView setDelegate:self];
  
  // Add explanation
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"text_filter_explanation.png"]];
  
  int x = (self.tableView.frame.size.width - imageView.frame.size.width) / 2;
  int y = -1 * (imageView.frame.size.height + 20);
  
  [imageView setFrame:CGRectMake(x, y, imageView.frame.size.width, imageView.frame.size.height)];
  
  [[self tableView] addSubview:imageView];
  [[self tableView] sendSubviewToBack:imageView];
  [[self tableView] setCanCancelContentTouches:NO];
  
  // Set background for tab buttons
  UIImage *buttonBackground = [[UIImage imageNamed:@"tab2.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:15];
  
  [_selectedIngredientsButton setBackgroundImage:buttonBackground forState:UIControlStateNormal];
  
  [self requestRecipes];
}

- (void)viewWillAppear:(BOOL)animated {
  // Reload the view as we could have changed the favorite state from within the cook recipe view
  if(_currRecipeView != nil) {
    [_recipeDetailView configureView:[_currRecipeView recipe]];
  }
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - CLRecipeDetailDelegate

- (void)recipeDetailView:(CLRecipeDetailView*)recipeDetailView didSelectShowRecipeWithRecipe:(CLRecipe*)recipe; {

  CLCookRecipeController *crc = [[CLCookRecipeController alloc] initWithRecipe:recipe];
  [self.navigationController pushViewController:crc animated:YES];
  
}

#pragma mark - CLRecipeDetailViewDelegate


- (void) showRecipeDetailView:(CLRecipeView *)viewVal {  
  // Already showing a recipe?
  if(_currRecipeView != nil) {
    return;
  }
  
  CLRecipe *recipeVal = [viewVal recipe];
  
  CGPoint flipViewCenterPoint = CGPointMake(_flipView.bounds.size.width/2, _flipView.bounds.size.height/2);
  CGPoint recipeGridViewCenterPoint = CGPointMake(_recipeGridView.bounds.size.width/2, _recipeGridView.bounds.size.height/2 + _recipeGridView.contentOffset.y);

  [_recipeGridView addSubview:_flipView];
  [_recipeGridView addSubview:_shadowView];
  
  // Save the current center point of the recipe in order to flip it back
  _currRecipeView = viewVal;
  _currRecipeCenterPoint = viewVal.center;
  
  // Disable table view interaction
  [self.tableView setUserInteractionEnabled:NO];
  
  // We need to set the flip views center to the center point of the current recipe.
  // After we have done that, we need to reposition the current recipe view in the flip view,
  // the same goes for the recipe detail view.
  // If we skip this step, the flip animation would result in some weird transition.
  _flipView.center = viewVal.center;
  viewVal.center = flipViewCenterPoint;
  _recipeDetailView.center = flipViewCenterPoint;
  
  // Position flip and shadow views in front of all recipe views
  [_recipeGridView bringSubviewToFront:_shadowView];
  [_recipeGridView bringSubviewToFront:_flipView];
  
  
  // Stop scrolling in recipe grid
  [_recipeGridView setScrollEnabled:NO];
  
  [_recipeDetailView configureView:recipeVal];
  
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
                                       
                                       [_shadowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]];
                                       
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
                    _flipView.center = _currRecipeCenterPoint;
                    
                    [_shadowView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0]];
                    
                    [_recipeDetailView removeFromSuperview];
                    [_flipView addSubview:_currRecipeView];
                  }
                  completion:^(BOOL finished) {
                    [_currRecipeView removeFromSuperview];
                    _currRecipeView.center = _currRecipeCenterPoint;
                    [_recipeGridView addSubview:_currRecipeView];
                    
                    [_shadowView removeFromSuperview];
                    [_flipView removeFromSuperview];
                    
                    // Unset current recipe view
                    _currRecipeView = nil;
                    
                    // Reenable scrolling
                    [_recipeGridView setScrollEnabled:YES];
                    
                    // Reenable table view user interaction
                    [self.tableView setUserInteractionEnabled:YES];
                  }];
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CLIngredient *currIngredient = [_selectedIngredients objectAtIndex:indexPath.row];
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  if([_currSelectedIngredients containsObject:currIngredient]) {
    [self setCellState:cell isSelected:NO];
    [_currSelectedIngredients removeObject:currIngredient];
  }
  else {
    [self setCellState:cell isSelected:YES];
    [_currSelectedIngredients addObject:currIngredient];
  }
  
  // Show activity indicator
  CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
  
  UIImageView *centerImage;
  if([_currSelectedIngredients count] > 0) {
    centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_FILTER]];
    [activityIndicator setSubMessage:@"Rezepte gefiltert"];
  }
  else {
    centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_FILTER_NO]];
    [activityIndicator setSubMessage:@"Filter entfernt"];
  }
  
  [activityIndicator setCenterView:centerImage];
  
  [activityIndicator show];
  [activityIndicator hideAfterDelay:2];
  
  [self displayFilteredRecipes];
}

#pragma mark - UITableViewDataSource

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
  CLIngredient *ingredient = (CLIngredient *)[_selectedIngredients objectAtIndex:indexPath.row];

  UIFont *font = [UIFont fontWithName:@"Noteworthy-Bold" size:18.0];
  
  [cell.textLabel setText:ingredient.name];
  [cell.textLabel setFont:font];
  [cell.textLabel setTextColor:[UIColor darkGrayColor]];
  
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_selectedIngredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"IngredientCell";
  
  UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  
  // Configure the cell.
  [self configureCell:cell atIndexPath:indexPath];
  
  return cell;
}

@end
