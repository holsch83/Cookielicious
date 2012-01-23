//
//  CLCookRecipeController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLCookRecipeController.h"
#import "CLFavoritesController.h"
#import "CLStepView.h"
#import "CLStepIngredient.h"
#import "CLStepScrollView.h"
#import "CLRecipe.h"
#import "CLStep.h"
#import "CLTimerView.h"
#import "CLTimersView.h"
#import "CLToolbar.h"
#import "CLActivityIndicator.h"
#import "DDPageControl.h"
#import "SHK.h"

#define CL_INGREDIENTVIEW_ROTATION -M_PI_4/10

@interface CLCookRecipeController (Private)

- (void)shareRecipe;
- (void)favoriteRecipe;
- (void)toggleLiveMode;
- (void)startLiveMode;
- (void)stopLiveMode;
- (BOOL)isLiveModeActive;
- (void)liveMode:(NSTimer *)theTimer;
- (void)setLiveModeTimerForStep:(CLStep *)theStep;
- (void)invalidateLiveModeTimer;
- (void)setLabelAlphaForContentOffset:(CGFloat)offset;
- (void)setIngredientsViewRotation:(CGFloat)offset;
- (void)createMultipleNavigationBarButtons;
- (void)configureFavoriteButton;
- (void)recipeFavoredSuccessfull;
- (void)createIngredientsList;
- (void)configurePageControl;

- (void)deleteCurrentTimer;
- (void)deleteAllTimers;

@end

@implementation CLCookRecipeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _recipe = nil;
  }
  return self;
}

- (id)initWithRecipe:(CLRecipe*)recipe {

  self = [super initWithNibName:@"CLCookRecipeController" bundle:nil];
  if (self) {
    _recipe = recipe;
    _timers = [[NSMutableArray alloc] init];
    
    // Action sheet
    _timerActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Timer löschen" otherButtonTitles:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(recipeFavoredSuccessfull) 
                                                 name:CL_NOTIFY_FAVORITE_ADDED
                                               object:nil];
  }
  return self;
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)enableTimerButton:(NSString *)timerName {
  // Reenable the timer button
  NSArray *subviews = [_scrollView subviews];
  for(UIView *subview in subviews) {
    if([subview respondsToSelector:@selector(enableTimer:)]) {
      [subview performSelector:@selector(enableTimer:) withObject:timerName];
    }
  }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  // Break, if no timer view is currently selected
  if(_currSelectedTimerView == nil || buttonIndex < 0) {
    return;
  }
  
  [self deleteCurrentTimer];
}


#pragma mark - CLStepViewDelegate

- (void) setTimer:(NSString *)timerName duration:(NSNumber *)duration {
  // Post local notification
  UILocalNotification* notification = [[UILocalNotification alloc] init];
  if(notification!=nil)
  {
    //Assign date for notification – endDate is the user selected endDate
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:([duration intValue] * 60)];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = timerName;
    notification.alertAction = @"Thanks!";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
  }
  
  // Configure a timer view and a timer
  /*CGRect rect = CGRectMake(0, 2, 60, 40);
  CLTimerView *timerView = [[CLTimerView alloc] initWithFrame:rect];
  [timerView setBackgroundColor:[UIColor blueColor]];*/
  [[NSBundle mainBundle] loadNibNamed:@"CLTimerView"
                                owner:self
                              options:nil];
  
  NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
  [userInfo setValue:[NSDate date] forKey:@"startDate"];
  [userInfo setValue:notification forKey:@"notification"];
  [userInfo setValue:duration forKey:@"duration"];
  [userInfo setValue:timerName forKey:@"timerName"];
  
  NSTimer *theTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:_timerView selector:@selector(updateTimer:) userInfo:userInfo repeats:YES];
  [_timerView setTimer:theTimer];
  [_timerView setDelegate:self];
  
  // Fire the timer once, for a initial update of the view
  [theTimer fire];
  
  [_timersView addSubview:_timerView];
  
  // Notify the user
  CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
  
  UIImageView *timerActivityImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_TIMER]];
  
  [activityIndicator setCenterView:timerActivityImageView];
  [activityIndicator setSubMessage:@"Timer gesetzt"];
  
  [activityIndicator show];
  [activityIndicator hideAfterDelay:2.0];
}

#pragma mark - CLTimerViewDelegate

- (void) touchedTimerView:(CLTimerView *)theView {
  _currSelectedTimerView = theView;
  
  // present popover view controller
  CGRect rect = CGRectMake(theView.frame.origin.x, self.view.frame.size.height - [theView superview].frame.size.height, theView.frame.size.width, theView.frame.size.height);
  
  [_timerActionSheet showFromRect:rect inView:self.view animated:YES];
}

- (void) timerFinished:(NSTimer *)theTimer forView:(UIView *)theView {
  NSLog(@"Timer finished");
  NSDictionary *userInfo = [theTimer userInfo];
  
  [self enableTimerButton:[userInfo objectForKey:@"timerName"]];
  
  // Remove the timer view
  [UIView animateWithDuration:0.3 animations:^{
    [theView setAlpha:0];
  } completion:^(BOOL finished) {
    [theView removeFromSuperview];
    [_timersView reorderSubviews];
  }];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createMultipleNavigationBarButtons];
  [self createIngredientsList];
  
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = _recipe.title;
  
  // Horizontal paging for the steps of the recipe...
  _scrollView.clipsToBounds = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.delegate = self;
  
  [self configurePageControl];
  
  float contentOffset = 0.0;
  int currentIndex = 0;
  
	for (CLStep *step in _recipe.steps) {
    
    // Load nib
		[[NSBundle mainBundle] loadNibNamed:@"CLStepView" 
                                  owner:self 
                                options:nil];
    
    // Set frame to place it on the right scroll view position
    CGRect stepViewFrame = CGRectMake(contentOffset, 0.0f, 
                                 _stepView.frame.size.width,
                                 _stepView.frame.size.height);
    _stepView.frame = stepViewFrame;
    [_stepView configureViewWithStep:step];
    [_stepView setDelegate:self];
		
    // Add POI view to scroll view
		[_scrollView addSubview:_stepView];
    
		contentOffset += _stepView.frame.size.width;
		_scrollView.contentSize = CGSizeMake(contentOffset, 
                                         _scrollView.frame.size.height);
    
    
    currentIndex++;
	}

  // Configure ingredients view  
  [_ingredientsView setFrame:CGRectMake(_ingredientsView.frame.origin.x, 95, _ingredientsView.frame.size.width, _ingredientsView.frame.size.height)];
  
  [_ingredientsView addSubview:_ingredientsTextView];
  [_ingredientsTextView setFrame:CGRectMake(40, 50, _ingredientsView.frame.size.width - 2*40, _ingredientsView.frame.size.height - 2 * 40)];
  
  _ingredientsViewInitialFrame = _ingredientsView.frame;
  
  [_scrollView setContentOffset:CGPointZero];
}

- (void)configurePageControl {
  
  // Set up page control
  _pageControl = [[DDPageControl alloc] init];
	[_pageControl setCenter: CGPointMake(self.view.bounds.size.width/2, 
                                       self.view.bounds.size.height - 125)];
  _pageControl.numberOfPages = [_recipe.steps count];
  _pageControl.currentPage = 0;
  _pageControl.userInteractionEnabled = NO;
  [_pageControl setType: DDPageControlTypeOnFullOffFull];
	[_pageControl setOnColor: [UIColor darkGrayColor]];
	[_pageControl setOffColor: [UIColor lightGrayColor]];
	[_pageControl setIndicatorDiameter: 5.0f];
	[_pageControl setIndicatorSpace: 10.0f];
	[self.view insertSubview:_pageControl 
              belowSubview:[_timersView superview]];

}

- (void)viewWillDisappear:(BOOL)animated {
  // Remove timers here
  [self deleteAllTimers];
  
  [self invalidateLiveModeTimer];
}

/**
 
 */
- (void)viewWillAppear:(BOOL)animated {
  if(_liveModeTimer != nil) {
    [_liveModeTimer invalidate];
    _liveModeTimer = nil;
  }
  _ingredientsView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CL_INGREDIENTVIEW_ROTATION);
  [_liveModeButton setImage:[UIImage imageNamed:CL_IMAGE_ICON_LIVE]];
}

#pragma mark - UIScrollViewDelegate

/**
 We want the live mode to be stopped, when the user drags the scroll view manually.
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  _blockLiveMode = YES;

  [self stopLiveMode];
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  _blockLiveMode = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  // Update the page number
  _pageControl.currentPage = [_scrollView currentPage];
  
  // Set start label transparancy
  [self setLabelAlphaForContentOffset:_scrollView.contentOffset.x];
  [self setIngredientsViewRotation:_scrollView.contentOffset.x];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
  if(_liveModeTimer != nil) {
    [self invalidateLiveModeTimer];
    
    if([_scrollView hasNextPage]) {
      CLStep *currStep = [[_recipe steps] objectAtIndex:[_scrollView currentPage]];
      [self setLiveModeTimerForStep:currStep];
    }
  }
  
  if(! [_scrollView hasNextPage]) {
    [self stopLiveMode];
  }
  
  // If the user taps the start button on the last page, the scroll view rewinds to the first page
  // and the live mode should start after the animation.
  if(_startLiveMode) {
    _startLiveMode = NO;
    [self startLiveMode];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if(_startLiveMode) {
    _startLiveMode = NO;
    [self startLiveMode];
  }
}

#pragma mark - Actions

- (void)createMultipleNavigationBarButtons {
  
  // Create buttons
  _shareButton = 
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                target:self 
                                                action:@selector(shareRecipe)];
  _shareButton.style = UIBarButtonItemStyleBordered;
  
  UIImage *image;
  if([[CLFavoritesController shared] isRecipeFavorite:_recipe]) {
    image = [UIImage imageNamed:CL_IMAGE_ICON_FAVED_NO];
  }
  else {
    image = [UIImage imageNamed:CL_IMAGE_ICON_FAVED];
  }
  
  _favoriteButton = 
  [[UIBarButtonItem alloc] initWithImage:image
                                   style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(favoriteRecipe)];
  _favoriteButton.style = UIBarButtonItemStyleBordered;
  
  _liveModeButton = 
  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ICON_LIVE]
                                   style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(toggleLiveMode)];
  
  // Add buttons to a toolbar
  CLToolbar* toolbar = [[CLToolbar alloc] initWithFrame:CGRectMake(0, 0, 160, 45)];
  NSArray* buttons = [NSArray arrayWithObjects:_liveModeButton, _shareButton, _favoriteButton, nil];
  [toolbar setItems:buttons animated:NO];
  
  // Set toolbar as right bar button item
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
}

- (void)createIngredientsList {

  NSMutableString *ingredientString = [[NSMutableString alloc] init];
  
  for(CLStepIngredient *ingr in [_recipe ingredients]) {
    // Only display decimal if number is not natural
    if([ingr amount] == 0) {
      [ingredientString appendFormat:@"\u2022 %@\n",[ingr name]];
    }
    else if([ingr amount] == floor([ingr amount])) {
      [ingredientString appendFormat:@"\u2022 %.0f %@\t%@\n",[ingr amount],[ingr unit],[ingr name]];
    }
    else {
      [ingredientString appendFormat:@"\u2022 %.02f %@\t%@\n",[ingr amount],[ingr unit],[ingr name]];
    }
  }
  _ingredientsTextView.text = ingredientString;
  
}

- (void)setIngredientsViewRotation:(CGFloat)offset {
  
  if (offset >= 0) {
    _ingredientsView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CL_INGREDIENTVIEW_ROTATION);
  
  }
  else if (offset <= -100) {
    _ingredientsView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, 0);
    
    // After the scroll view decelerated, we need to reset the ingredient view to its initial position
    [_ingredientsView setFrame:_ingredientsViewInitialFrame];
  }
  else if (offset < 0 && offset > -100) {
    _ingredientsView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CL_INGREDIENTVIEW_ROTATION + CL_INGREDIENTVIEW_ROTATION * (offset/100));
  }
  
  if(offset < -200) {
    // Stick the ingredients to the step
    float x = abs(offset) - 200;
    
    CGRect rect = CGRectMake(_ingredientsViewInitialFrame.origin.x + x, _ingredientsView.frame.origin.y, _ingredientsView.frame.size.width, _ingredientsView.frame.size.height);
    
    [_ingredientsView setFrame:rect];
  }
  else if(offset > _scrollView.contentSize.width - _scrollView.frame.size.width + 75) {
    float x = (_scrollView.contentSize.width - _scrollView.frame.size.width + 75) - offset;
    
    CGAffineTransform tmpTransform = _ingredientsView.transform;
    _ingredientsView.transform = CGAffineTransformIdentity;
    
    CGRect rect = CGRectMake(_ingredientsViewInitialFrame.origin.x + x, _ingredientsView.frame.origin.y, _ingredientsView.frame.size.width, _ingredientsView.frame.size.height);
    
    [_ingredientsView setFrame:rect];
    
    _ingredientsView.transform = tmpTransform;
  }
}

- (void)setLabelAlphaForContentOffset:(CGFloat)offset {
  
  
  if (offset < 0) {
    _startLabel.alpha = 1.0;
  }
  else if (offset > 100) {
    _startLabel.alpha = 0.0;
  }
  else {
    _startLabel.alpha = 1 - (offset/100);
  }
}

- (void)shareRecipe {
  if (_sharingActionSheet) {
    [_sharingActionSheet dismissWithClickedButtonIndex:-1 
                                              animated:YES];
    _sharingActionSheet = nil;
    return;
  }
  
  // Create the item to share (in this example, a url)
  NSString *shareText = [NSString stringWithFormat:@"Koche gerade mit Cookielicious \"%@\"! Mjamm!", _recipe.title];
  SHKItem *item = [SHKItem text:shareText];
  
  // Get the ShareKit action sheet
  _sharingActionSheet = [SHKActionSheet actionSheetForItem:item];
  
  // Display the action sheet
  [_sharingActionSheet showFromBarButtonItem:_shareButton
                                    animated:YES];
}

- (void)favoriteRecipe {
  if(! [[CLFavoritesController shared] isRecipeFavorite:_recipe]) {
    
    [[CLFavoritesController shared] addFavoriteWithRecipe:_recipe];
    [_favoriteButton setEnabled:NO];

  }
  else {
    [[CLFavoritesController shared] removeFavoriteWithRecipe:_recipe];
    
    [_favoriteButton setImage:[UIImage imageNamed:CL_IMAGE_ICON_FAVED]];
    
    CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
    
    UIImageView *centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_FAVED_NO]];
    
    [activityIndicator setCenterView:centerImage];
    [activityIndicator setSubMessage:@"Favorit entfernt"];
    
    [activityIndicator show];
    [activityIndicator hideAfterDelay:2];
  }
}

- (void)configureFavoriteButton {
  
  if([[CLFavoritesController shared] isRecipeFavorite:_recipe]) {
    [_favoriteButton setImage:[UIImage imageNamed:CL_IMAGE_ICON_FAVED_NO]];
  }
  else {
    [_favoriteButton setImage:[UIImage imageNamed:CL_IMAGE_ICON_FAVED]];
  }
  
}

- (void)deleteCurrentTimer {
  NSTimer *theTimer = [_currSelectedTimerView timer];
  NSDictionary *userInfo = (NSDictionary *)[theTimer userInfo];
  
  // Remove the local notification
  [[UIApplication sharedApplication] cancelLocalNotification:(UILocalNotification *)[userInfo objectForKey:@"notification"]];
  
  // Remove the timer view
  [UIView animateWithDuration:0.3 animations:^{
    [_currSelectedTimerView setAlpha:0];
  } completion:^(BOOL finished) {
    if(finished) {
      [_currSelectedTimerView removeFromSuperview];
      [_timersView reorderSubviews];
      
      _currSelectedTimerView = nil;
    }
  }];
  
  // Stop the timer
  [theTimer invalidate];
  
  [self enableTimerButton:[userInfo objectForKey:@"timerName"]];
  
  // Show activity indicator
  CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
  
  UIImageView *timerActivityImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_TIMER_NO]];
  
  [activityIndicator setCenterView:timerActivityImageView];
  [activityIndicator setSubMessage:@"Timer gelöscht"];
  
  [activityIndicator show];
  [activityIndicator hideAfterDelay:2.0];
}

- (void)deleteAllTimers {
  for (CLTimerView *currView in [_timersView subviews]) {
    NSTimer *theTimer = [currView timer];
    NSDictionary *userInfo = (NSDictionary *)[theTimer userInfo];
    
    // Remove the local notification
    [[UIApplication sharedApplication] cancelLocalNotification:(UILocalNotification *)[userInfo objectForKey:@"notification"]];
    
    // Remove the timer view
    [currView removeFromSuperview];
    
    // Stop the timer
    [theTimer invalidate]; 
  }
}

#pragma mark - NSNotification

- (void)recipeFavoredSuccessfull {
  
  [_favoriteButton setEnabled:YES];
  [self configureFavoriteButton];
  
  // Show activity indicator
  CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
  
  UIImageView *centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_FAVED]];
  
  [activityIndicator setCenterView:centerImage];
  [activityIndicator setSubMessage:@"Als Favorit markiert"];
  
  [activityIndicator show];
  [activityIndicator hideAfterDelay:2];
  
}


#pragma mark - Live mode

- (void)toggleLiveMode {
  // Block live mode is set to yes, when the user starts dragging the scroll view
  if(_blockLiveMode) {
    _startLiveMode = YES;
    return;
  }
  
  if(_liveModeTimer == nil) {
    [self startLiveMode];
  }
  else {
    [self stopLiveMode];
  }
}

- (void)startLiveMode {
  // Only start live mode if we are not on recipes last page
  if(! [_scrollView hasNextPage]) {
    _startLiveMode = YES;
    [_scrollView setContentOffset:CGPointZero animated:YES];
  }
  
  if(_scrollView.contentOffset.x < 0) {
    [_scrollView setContentOffset:CGPointZero animated:YES];
  }
  
  CLStep *currStep = [[_recipe steps] objectAtIndex:[_scrollView currentPage]];
  [self setLiveModeTimerForStep:currStep];
  
  [_liveModeButton setImage:[UIImage imageNamed:CL_IMAGE_ICON_LIVE_NO]];
  
  UIImageView *centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_LIVE]];
  
  CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
  [activityIndicator setCenterView:centerImage];
  [activityIndicator setSubMessage:@"Livemodus gestartet"];
  
  [activityIndicator show];
  [activityIndicator hideAfterDelay:1.4];
}

- (void)stopLiveMode; {
  // Only present activity indicator, if live mode is active
  if([self isLiveModeActive]) {
    UIImageView *centerImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ACTION_LIVE_NO]];
    
    CLActivityIndicator *activityIndicator = [CLActivityIndicator currentIndicator];
    [activityIndicator setCenterView:centerImage];
    [activityIndicator setSubMessage:@"Livemodus beendet"];
    
    [activityIndicator show];
    [activityIndicator hideAfterDelay:1.4];
  }
  
  [self invalidateLiveModeTimer];
  
  [_liveModeButton setImage:[UIImage imageNamed:CL_IMAGE_ICON_LIVE]];
}

- (BOOL)isLiveModeActive {
  return _liveModeTimer != nil;
}

/**
 This method is invoked when the current timer for a step elapsed.
 */
- (void)liveMode:(NSTimer *)theTimer {
  [_scrollView scrollToNextPageAnimated:YES];
}

- (void)setLiveModeTimerForStep:(CLStep *)theStep {
  [self invalidateLiveModeTimer];
  
  _liveModeTimer = [NSTimer scheduledTimerWithTimeInterval:([theStep duration]) target:self selector:@selector(liveMode:) userInfo:nil repeats:NO];
}

- (void)invalidateLiveModeTimer {
  if(_liveModeTimer != nil) {
    [_liveModeTimer invalidate];
    _liveModeTimer = nil;
  }
}


@end
