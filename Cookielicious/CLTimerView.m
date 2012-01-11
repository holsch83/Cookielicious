//
//  CLTimerView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLTimerView.h"

@implementation CLTimerView

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if(self) {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedView)];
    [self addGestureRecognizer:_tapGestureRecognizer];
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
  
  int minutes = ([[userInfo objectForKey:@"duration"] intValue]*60 - interval) / 60;
  
  NSLog(@"Updating timer. Time left until finished: %d minutes", minutes);
}

@end
