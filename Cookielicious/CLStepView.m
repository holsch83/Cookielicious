//
//  CLStepView.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLStepView.h"
#import "CLStep.h"
#import "CLTodo.h"
#import "CLStepIngredient.h"

@implementation CLStepView

@synthesize delegate = _delegate;

- (void)enableTimer:(NSString *)timerName {
  if([_step.timerName isEqualToString:timerName]) {
    [_setTimerButton setEnabled:YES];
  }
}

- (IBAction)touchedSetTimerButton:(id)sender {
  if([_delegate respondsToSelector:@selector(setTimer:duration:)]) {
    [_delegate performSelector:@selector(setTimer:duration:) withObject:_step.timerName withObject:[NSNumber numberWithInt:_step.duration]];
    
    // Disable button after timer has been added
    [_setTimerButton setEnabled:NO];
  }
}

- (void)drawRect:(CGRect)rect {
  
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(currentContext);
  CGContextSetShadow(currentContext, CGSizeMake(0, 0), 10);
  
  // draw the rect
  CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height - 20);
  CGContextSetRGBFillColor(currentContext, 255, 255, 255, 1);
  CGContextFillRect(currentContext, newRect);
  
  CGContextRestoreGState(currentContext);
}

- (void)configureViewWithStep:(CLStep *)step {
  _step = step;
  
  _imageView.image = step.image;
  _durationLabel.text = [NSString stringWithFormat:@"%i Min", step.duration];
  _titleLabel.text = [NSString stringWithFormat:@"%@", step.title];
  _descriptionText.text = [NSString stringWithFormat:@"%@", step.description];
  
  // Set TODOs as bulleted list
  NSMutableString *todoString = [[NSMutableString alloc] init];
  for(CLTodo *todo in [step todos]) {
    [todoString appendFormat:@"\u2022 %@\n",[todo description]];
  }
  _todoText.text = todoString;
  
  // Show or hide timer button
  if([step.timeable boolValue]) {
    [_setTimerButton setHidden:NO]; 
  }
  else {
    [_setTimerButton setHidden:YES];
  }
  
  // Set Ingredients List, separated with a dash
  NSMutableString *ingredientsString = [[NSMutableString alloc] init];
  
  for (int i=0; i<[[step ingredients] count]; i++) {
    CLStepIngredient *ingr = [[step ingredients] objectAtIndex:i];
    if (i == 0)
      [ingredientsString appendFormat:@"%@", [ingr name]];
    else
      [ingredientsString appendFormat:@" - %@", [ingr name]];
  }
  _ingredientsText.text = ingredientsString;
}

@end
