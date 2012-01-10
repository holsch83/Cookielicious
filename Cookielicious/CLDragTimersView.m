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
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touches began");
  
  UITouch *touch = [touches anyObject];
  
  touchStartFrame = [[self superview] frame];
  touchStartPoint = [touch locationInView:[[self superview] superview]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[[self superview] superview]];
  float dy = touchStartPoint.y - currPoint.y;
  
  NSLog(@"Touches moved, dy: %f", dy);
  
  if((! isShowing && dy >= 0 && dy <= 44) || (isShowing && dy <= 0 && dy >= -44)) {
    UIView *superview = [self superview];
    CGPoint currSuperviewOrigin = CGPointMake(touchStartFrame.origin.x, touchStartFrame.origin.y - dy);
    
    [superview setFrame:CGRectMake(currSuperviewOrigin.x, currSuperviewOrigin.y, superview.frame.size.width, superview.frame.size.height)];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[[self superview] superview]];
  float dy = touchStartPoint.y - currPoint.y;
  
  if(! isShowing && dy > 0) {
    isShowing = true;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview]  setFrame:CGRectMake(touchStartFrame.origin.x, touchStartFrame.origin.y - 44, touchStartFrame.size.width, touchStartFrame.size.height)];
    }];
  }
  else if(isShowing && dy < 0) {
    isShowing = false;
    
    [UIView animateWithDuration:.3 animations:^{
      [[self superview] setFrame:CGRectMake(touchStartFrame.origin.x, touchStartFrame.origin.y + 44, touchStartFrame.size.width, touchStartFrame.size.height)];
    }];
  }
}

@end
