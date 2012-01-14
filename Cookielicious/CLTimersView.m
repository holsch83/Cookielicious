//
//  CLTimersView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLTimersView.h"

#define CL_VIEW_OFFSET 15

@implementation CLTimersView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    _currOffset = CL_VIEW_OFFSET;
  }
  return self;
}

- (void)addSubview:(UIView *)view {  
  [super addSubview:view];
  
  if ([view isKindOfClass:NSClassFromString(@"CLTimerView")]) {
    [view setFrame:CGRectMake(_currOffset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    
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
      _currOffset += subview.frame.size.width + CL_VIEW_OFFSET;
    }
  }
}

@end