//
//  CLTimerView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <math.h>
#import "CLTimerView.h"
#import "CLTimersView.h"

@implementation CLTimerView

@synthesize delegate = _delegate;
@synthesize timer = _timer;
@synthesize timerNameLabel = _timerNameLabel;
@synthesize timeLeftLabel = _timeLeftLabel;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedView)];
    [self addGestureRecognizer:_tapGestureRecognizer];
    
    // Center vertically in superview
    [self setFrame:CGRectMake(self.frame.origin.x, 2, self.frame.size.width, self.frame.size.height)];
  }
  return self;
}

// Delegate the touch to CLTimersView
- (void) touchedView {
  if([_delegate respondsToSelector:@selector(touchedTimerView:)]) {
    [_delegate performSelector:@selector(touchedTimerView:) withObject:self];
  }
}

// The update callback for the timer
- (void) updateTimer:(NSTimer *)theTimer {
  NSDictionary *userInfo = (NSDictionary *) [theTimer userInfo];
  NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:[userInfo objectForKey:@"startDate"]];
  
  float seconds = ([[userInfo objectForKey:@"duration"] floatValue]*60 - interval);
  int minutes = ceilf(seconds / 60);
  
  [[self timerNameLabel] setText:[userInfo objectForKey:@"timerName"]];
  [[self timeLeftLabel] setText:[NSString stringWithFormat:@"%d Minuten", minutes]];
  
  // Stop the timer and remove the view
  if(seconds <= 0) {
    [theTimer invalidate];

    CLTimersView *superview = (CLTimersView *)[self superview];
    [self removeFromSuperview];
    [superview reorderSubviews];
  }
  
  NSLog(@"Updating timer. Time left until finished: %d minutes", minutes);
}

@end
