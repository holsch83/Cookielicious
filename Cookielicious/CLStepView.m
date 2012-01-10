//
//  CLStepView.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLStepView.h"
#import "CLStep.h"

@implementation CLStepView

@synthesize delegate = _delegate;

- (void)configureViewWithStep:(CLStep *)step {

  _step = step;
  
  _titleLabel.text = [NSString stringWithFormat:@"%@", step.title];
  _descriptionLabel.text = [NSString stringWithFormat:@"%@", step.description];

  // TODO: Show or hide button
  if([step.timeable boolValue]) {
    [_setTimerButton setHidden:NO]; 
  }
  else {
    [_setTimerButton setHidden:YES];
  }
}

- (IBAction)touchedSetTimerButton:(id)sender {
  NSLog(@"Touched set timer button");
  if([_delegate respondsToSelector:@selector(setTimer:duration:)]) {
    NSNumber *result = [_delegate performSelector:@selector(setTimer:duration:) withObject:_step.timerName withObject:[NSNumber numberWithInt:_step.duration]];
    
    // Disable button, if timer has been added successful
    if([result boolValue]) {
      [_setTimerButton setEnabled:NO];
    }
  }
}

@end
