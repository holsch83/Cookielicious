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
#import "CLTimerPopoverViewControllerDelegate.h"

@class CLStepView;
@class CLRecipe;
@class CLTimersView;

@interface CLCookRecipeController : UIViewController <CLStepViewDelegate, CLTimerViewDelegate, CLTimerPopoverViewControllerDelegate> {

  IBOutlet CLTimersView *_timersView;
  IBOutlet UIScrollView *_scrollView;
  IBOutlet CLStepView *_stepView;
  IBOutlet CLTimerView *_timerView;
  CLRecipe *_recipe;
  
  CLTimerView *_currSelectedTimerView;
  UIPopoverController *_timerPopoverController;
  
  // The timers for the current recipe
  NSMutableArray *_timers;
}

- (id)initWithRecipe:(CLRecipe*)recipe;
- (void)enableTimerButton:(NSString *)timerName;

@end
