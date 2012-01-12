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

@synthesize delegate = _delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    _currOffset = CL_VIEW_OFFSET;
    
    CLTimerPopoverViewController *popoverViewController = [[CLTimerPopoverViewController alloc] init];
    [popoverViewController setDelegate:self];
    
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

// After a timer has been deleted, we need to rearrange the active timer views,
// in order to fill the gap.
- (void)reorderSubviews {
  // Reset the offset to its initial value
  _currOffset = CL_VIEW_OFFSET;
  
  // Iterate over the subviews, setting the x offset of all CLTimerView objects
  NSArray *subviews = [self subviews];
  for(UIView *subview in subviews) {
    if([subview isKindOfClass:NSClassFromString(@"CLTimerView")]) {
      [UIView animateWithDuration:.3 animations:^{
        [subview setFrame:CGRectMake(_currOffset, subview.frame.origin.y, subview.frame.size.width, subview.frame.size.height)];
      }];
      _currOffset += CL_VIEW_OFFSET;
    }
  }
}

#pragma mark - CLTimerViewDelegate

- (void)touchedTimerView:(CLTimerView *)theView {
  _currSelectedTimerView = theView;
  
  CGRect frame = [self frame];
  CGRect viewFrame = [theView frame];
  
  CGRect rect = CGRectMake(frame.origin.x + viewFrame.origin.x, frame.origin.y + viewFrame.origin.y, viewFrame.size.width, viewFrame.size.height);
  [_popoverController presentPopoverFromRect:rect inView:[self superview] permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
}

#pragma mark - CLTimerPopoverViewControllerDelegate

- (void)touchedTimerDeleteButton {
  if(_currSelectedTimerView != nil) {
    if([_delegate respondsToSelector:@selector(deleteTimer:forView:)]) {
      [_delegate performSelector:@selector(deleteTimer:forView:) withObject:[_currSelectedTimerView timer] withObject:_currSelectedTimerView];
    }
    
    [_popoverController dismissPopoverAnimated:YES];
    _currSelectedTimerView = nil;
  }
}

@end
