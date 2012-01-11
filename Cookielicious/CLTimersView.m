//
//  CLTimersView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLTimersView.h"
#import "CLTimerView.h"
#import "CLTimerPopoverViewController.h"

#define CL_VIEW_OFFSET 15

@implementation CLTimersView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    _currOffset = CL_VIEW_OFFSET;
    
    CLTimerPopoverViewController *popoverViewController = [[CLTimerPopoverViewController alloc] init];
    _popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverViewController];
    [_popoverController setPopoverContentSize:popoverViewController.view.frame.size];
    
  }
  return self;
}

- (void)addSubview:(UIView *)view {
  [super addSubview:view];
  
  if ([view isKindOfClass:NSClassFromString(@"CLTimerView")]) {
    [view setFrame:CGRectMake(_currOffset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];

    // Set the delegate for presenting the view controller
    [(CLTimerView *)view setDelegate:self];
    
    // Update the current offset
    _currOffset += view.frame.size.width + CL_VIEW_OFFSET;
  }
}

#pragma mark - CLTimerViewDelegate

- (void)touchedTimerView:(CLTimerView *)theView {
  CGRect frame = [self frame];
  CGRect viewFrame = [theView frame];
  
  CGRect rect = CGRectMake(frame.origin.x + viewFrame.origin.x, frame.origin.y + viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
  [_popoverController presentPopoverFromRect:rect inView:[self superview] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

@end
