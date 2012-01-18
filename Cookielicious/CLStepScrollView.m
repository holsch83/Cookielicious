//
//  CLStepScrollView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 18.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLStepScrollView.h"

@implementation CLStepScrollView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedView:)];
    [self addGestureRecognizer:_tapGestureRecognizer];
  }
  return self;
}

- (void)touchedView:(UIGestureRecognizer *)gestureRecognizer {
  CGPoint point = [gestureRecognizer locationInView:self];
  
  if((point.x - self.contentOffset.x) < 0) {
    [self scrollToPreviousPageAnimated:YES];
  }
  else if((point.x - self.contentOffset.x) >= self.frame.size.width) {
    [self scrollToNextPageAnimated:YES];
  }
}

- (void) scrollToPreviousPageAnimated:(BOOL)animated {
  if([self hasPreviousPage]) {
    CGPoint offset = CGPointMake(self.contentOffset.x - self.frame.size.width, self.contentOffset.y);
    [self setContentOffset:offset animated:animated];
  }
}

- (void) scrollToNextPageAnimated:(BOOL)animated {
  if([self hasNextPage]) {
    CGPoint offset = CGPointMake(self.contentOffset.x + self.frame.size.width, self.contentOffset.y);
    [self setContentOffset:offset animated:animated];
  }
}

- (BOOL) hasPreviousPage {
  return (self.contentOffset.x - self.frame.size.width) >= 0;
}

- (BOOL) hasNextPage {
  return (self.contentOffset.x + self.frame.size.width) < self.contentSize.width;
}

@end
