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
    _originFrame = [self frame];
  }
  return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSLog(@"Touches began");
  
  UITouch *touch = [touches anyObject];
  
  _touchStartFrame = [self frame];
  _touchStartPoint = [touch locationInView:[self superview]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[self superview]];
  float dy = _touchStartPoint.y - currPoint.y;
  
  NSLog(@"Touches moved, dy: %f", dy);
  
  if((! isShowing && dy >= 0 && dy <= 44) || (isShowing && dy <= 0 && dy >= -44)) {
    CGPoint currOrigin = CGPointMake(_touchStartFrame.origin.x, _touchStartFrame.origin.y - dy);
    
    [self setFrame:CGRectMake(currOrigin.x, currOrigin.y, self.frame.size.width, self.frame.size.height)];
  }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint currPoint = [touch locationInView:[self superview]];
  float dy = _touchStartPoint.y - currPoint.y;
  
  if(! isShowing && dy > 0) {
    isShowing = true;
    
    [UIView animateWithDuration:.3 animations:^{
      [self setFrame:CGRectMake(_originFrame.origin.x, _originFrame.origin.y - 44, _originFrame.size.width, _originFrame.size.height)];
    }];
  }
  else if(isShowing && dy < 0) {
    isShowing = false;
    
    [UIView animateWithDuration:.3 animations:^{
      [self setFrame:CGRectMake(_originFrame.origin.x, _originFrame.origin.y, _originFrame.size.width, _originFrame.size.height)];
    }];
  }
}

- (void)addSubview:(UIView *)view {
  [super addSubview:view];
  
  if ([view isKindOfClass:NSClassFromString(@"CLTimerView")]) {
    [view setFrame:CGRectMake(_currOffset, view.frame.origin.y, view.frame.size.width, view.frame.size.height)];
    _currOffset += view.frame.size.width;
  }
}

@end
