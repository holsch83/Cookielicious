//
//  CLCookRecipeController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLCookRecipeController.h"
#import "CLStepView.h"
#import "CLRecipe.h"
#import "CLStep.h"
#import "CLTimerView.h"
#import "CLTimersView.h"

@implementation CLCookRecipeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
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
  }
  return self;
}


#pragma mark - CLStepViewDelegate

- (NSNumber *) setTimer:(NSString *)timerName duration:(NSNumber *)duration {
  NSLog(@"Set a timer %@ with duration %d", timerName, [duration intValue]);
  
  // Post local notification
  UILocalNotification* notification = [[UILocalNotification alloc] init];
  if(notification!=nil)
  {
    //Assign date for notification – endDate is the user selected endDate
    notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:[duration intValue] * 60];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.alertBody = timerName;
    notification.alertAction = @"Thanks!";
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
  }
  
  // Configure a timer view and a timer
  CGRect rect = CGRectMake(0, 2, 60, 40);
  CLTimerView *timerView = [[CLTimerView alloc] initWithFrame:rect];
  [timerView setBackgroundColor:[UIColor blueColor]];
  
  [_timersView addSubview:timerView];
  
  return [NSNumber numberWithInt:1];
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Do any additional setup after loading the view from its nib.
  self.navigationItem.title = _recipe.title;
  _scrollView.clipsToBounds = NO;
	_scrollView.pagingEnabled = YES;
	_scrollView.showsHorizontalScrollIndicator = NO;
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



@end
