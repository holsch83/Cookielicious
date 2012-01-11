//
//  CLCookRecipeController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLCookRecipeController.h"
#import "CLTimerPopoverViewController.h"
#import "CLStepView.h"
#import "CLRecipe.h"
#import "CLStep.h"
#import "CLTimerView.h"
#import "CLTimersView.h"
#import "SHK.h"

@interface CLCookRecipeController (Private)

- (void)setLabelAlphaForContentOffset:(CGFloat)offset;

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
    
    // Initialize and configure the popover controller
    CLTimerPopoverViewController *popoverViewController = [[CLTimerPopoverViewController alloc] init];
    [popoverViewController setDelegate:self];
    
    _timerPopoverController = [[UIPopoverController alloc] initWithContentViewController:popoverViewController];
    [_timerPopoverController setPopoverContentSize:popoverViewController.view.frame.size];
  }
  return self;
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

#pragma mark - CLTimerPopoverViewControllerDelegate

- (void)touchedTimerDeleteButton {
  // Break, if no timer view is currently selected
  if(_currSelectedTimerView == nil) {
    return;
  }
  
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
  
  [_timerPopoverController dismissPopoverAnimated:YES];
}


#pragma mark - CLStepViewDelegate

- (void) setTimer:(NSString *)timerName duration:(NSNumber *)duration {
  NSLog(@"Set a timer %@ with duration %d", timerName, [duration intValue]);
  
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
}

#pragma mark - CLTimerViewDelegate
- (void) touchedTimerView:(CLTimerView *)theView {
  _currSelectedTimerView = theView;
  
  // present popover view controller
  CGRect rect = CGRectMake(theView.frame.origin.x, self.view.frame.size.height - [theView superview].frame.size.height, theView.frame.size.width, theView.frame.size.height);
  
  [_timerPopoverController presentPopoverFromRect:rect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
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
	return (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? YES : NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = _recipe.title;
  self.navigationItem.rightBarButtonItem = 
  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                target:self 
                                                action:@selector(shareRecipe)];
  
  // Horizontal paging for the steps of the recipe...
  _scrollView.clipsToBounds = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
  _scrollView.delegate = self;
  
  // Set up page control
  _pageControl.numberOfPages = [_recipe.steps count];
  _pageControl.currentPage = 0;
  
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

}


- (void)viewWillDisappear:(BOOL)animated {
  NSLog(@"View will disappear");
  // Remove timers here
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
  // Update the page number
  CGFloat pageWidth = _scrollView.frame.size.width;
  _pageControl.currentPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  
  // Set start label transparancy
  [self setLabelAlphaForContentOffset:_scrollView.contentOffset.x];
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

  NSLog(@"Sharing Recipe ...");
  
  // Create the item to share (in this example, a url)
  NSString *shareText = [NSString stringWithFormat:@"Koche gerade mit Cookielicious \"%@\"! Mjamm!", _recipe.title];
  SHKItem *item = [SHKItem text:shareText];
    
  // Get the ShareKit action sheet
  SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
  
  // Display the action sheet
  [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem 
                            animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
