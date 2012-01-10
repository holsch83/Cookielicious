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
  NSLog(@"Init with coder");
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
    _currOffset += view.frame.size.width + CL_VIEW_OFFSET;
  }
}

@end
