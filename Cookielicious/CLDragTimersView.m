//
//  CLDragTimersView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLDragTimersView.h"

#define CL_DRAG_TIMERS_VIEW_RECT_HIDDEN CGRectMake(0, 660, 1024, 94)
#define CL_DRAG_TIMERS_VIEW_RECT CGRectMake(0, 616, 1024, 94)

@interface CLDragTimersView (Private)

- (void) slideView;

@end

@implementation CLDragTimersView

- (id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    isShowing = false;
    _currOffset = 0;
    
    // Tap gesture recognizer
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideView)];
    [self addGestureRecognizer:_tapGestureRecognizer];
  }
  return self;
}

#pragma mark - Private

- (void)slideView {
  if(! isShowing) {
    isShowing = true;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview] setFrame:CL_DRAG_TIMERS_VIEW_RECT];
    }];
  }
  else {
    isShowing = false;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview] setFrame:CL_DRAG_TIMERS_VIEW_RECT_HIDDEN];
    }];
  }
}

#pragma mark - Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  
  _originFrame = [[self superview] frame];
  _touchStartFrame = [[self superview] frame];
  _touchStartPoint = [touch locationInView:[[self superview] superview]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[[self superview] superview]];
  float dy = _touchStartPoint.y - currPoint.y;
  
  if((! isShowing && dy >= 0 && dy <= 44) || (isShowing && dy <= 0 && dy >= -44)) {
    CGPoint currOrigin = CGPointMake(_touchStartFrame.origin.x, _touchStartFrame.origin.y - dy);
    
    [[self superview] setFrame:CGRectMake(currOrigin.x, currOrigin.y, [self superview].frame.size.width, [self superview].frame.size.height)];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[[self superview] superview]];

  float dy = _touchStartPoint.y - currPoint.y;

  if(dy > 0) {
    isShowing = true;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview] setFrame:CL_DRAG_TIMERS_VIEW_RECT];
    }];
  }
  else if(dy < 0) {
    isShowing = false;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview] setFrame:CL_DRAG_TIMERS_VIEW_RECT_HIDDEN];
    }];
  }
}

@end
