//
//  CLDragTimersView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLDragTimersView.h"

@implementation CLDragTimersView

- (id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    isShowing = false;
    _currOffset = 0;
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touches began");
  
  UITouch *touch = [touches anyObject];
  
  _originFrame = [[self superview] frame];
  _touchStartFrame = [[self superview] frame];
  _touchStartPoint = [touch locationInView:[[self superview] superview]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[[self superview] superview]];
  float dy = _touchStartPoint.y - currPoint.y;
  
  NSLog(@"Touches moved, dy: %f", dy);
  
  if((! isShowing && dy >= 0 && dy <= 44) || (isShowing && dy <= 0 && dy >= -44)) {
    CGPoint currOrigin = CGPointMake(_touchStartFrame.origin.x, _touchStartFrame.origin.y - dy);
    
    [[self superview] setFrame:CGRectMake(currOrigin.x, currOrigin.y, [self superview].frame.size.width, [self superview].frame.size.height)];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[[self superview] superview]];
  float dy = _touchStartPoint.y - currPoint.y;
  NSLog(@"_originFrame, x: %f, y: %f, w: %f, h: %f", _originFrame.origin.x, _originFrame.origin.y, _originFrame.size.width, _originFrame.size.height);
  if(! isShowing && dy > 0) {
    isShowing = true;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview] setFrame:CGRectMake(_originFrame.origin.x, _originFrame.origin.y - 44, _originFrame.size.width, _originFrame.size.height)];
    }];
  }
  else if(isShowing && dy < 0) {
    isShowing = false;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview] setFrame:CGRectMake(_originFrame.origin.x, _originFrame.origin.y + 44, _originFrame.size.width, _originFrame.size.height)];
    }];
  }
}

@end
