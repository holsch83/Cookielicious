//
//  CLCookRecipeController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTimerView.h"
#import "CLStepViewDelegate.h"
#import "CLTimerViewDelegate.h"

@class CLStepView;
@class CLRecipe;
@class CLTimersView;
@class SHKActionSheet;
@class CLStepScrollView;

@interface CLCookRecipeController : UIViewController <UIScrollViewDelegate, CLStepViewDelegate, CLTimerViewDelegate, UIActionSheetDelegate> {

  IBOutlet CLTimersView *_timersView;
  IBOutlet CLStepScrollView *_scrollView;
  IBOutlet CLStepView *_stepView;
  IBOutlet CLTimerView *_timerView;
  IBOutlet UIPageControl *_pageControl;
  IBOutlet UILabel *_startLabel;
  
  UIBarButtonItem *_shareButton;
  UIBarButtonItem *_favoriteButton;
  UIBarButtonItem *_liveModeButton;
  
  // Live mode
  NSTimer *_liveModeTimer;
  
  CLRecipe *_recipe;
  
  CLTimerView *_currSelectedTimerView;
  UIActionSheet *_timerActionSheet;
  SHKActionSheet *_sharingActionSheet;
  
  // The timers for the current recipe
  NSMutableArray *_timers;
}

- (id)initWithRecipe:(CLRecipe*)recipe;
- (void)enableTimerButton:(NSString *)timerName;

- (IBAction) previousStep:(id)sender;
- (IBAction) nextStep:(id)sender;

@end
