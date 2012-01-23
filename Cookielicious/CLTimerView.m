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
    
    // Set background
    UIImage *timerBackground = [[UIImage imageNamed:@"timer.png"] stretchableImageWithLeftCapWidth:17 topCapHeight:19];
    UIImageView *timerBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [timerBackgroundImageView setImage:timerBackground];
    
    [self addSubview:timerBackgroundImageView];
    [self sendSubviewToBack:timerBackgroundImageView];
    
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
  [[self timeLeftLabel] setText:[NSString stringWithFormat:@"in %d Minuten", minutes]];
  
  // Stop the timer and remove the view
  if(seconds <= 0) {
    if([_delegate respondsToSelector:@selector(timerFinished:forView:)]) {
      [_delegate performSelector:@selector(timerFinished:forView:) withObject:[self timer] withObject:self];
    }
    
    [theTimer invalidate];
  }
}

@end
