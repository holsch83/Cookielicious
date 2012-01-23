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
    [_tapGestureRecognizer setDelegate:self];
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
    CGPoint offset = CGPointMake(([self currentPage] - 1) * self.frame.size.width, self.contentOffset.y);
    [self setContentOffset:offset animated:animated];
  }
}

- (void) scrollToNextPageAnimated:(BOOL)animated {
  if([self hasNextPage]) {
    CGPoint offset = CGPointMake(([self currentPage] + 1) * self.frame.size.width, self.contentOffset.y);
    [self setContentOffset:offset animated:animated];
  }
}

- (BOOL) hasPreviousPage {
  return [self currentPage] > 0;
}

- (BOOL) hasNextPage {
  return (([self currentPage] + 1) * self.frame.size.width) < self.contentSize.width;
}

- (int) currentPage {
  int maxPage = ceil(self.contentSize.width / self.frame.size.width) - 1;
  int currPage = (int) round(self.contentOffset.x / self.frame.size.width);

  if(currPage < 0) {
    return 0;
  }
  else if(currPage > maxPage) {
    return maxPage;
  }
  else {
    return currPage;
  }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if([touch.view isKindOfClass:NSClassFromString(@"UIButton")]) {
    return NO;
  }
  return YES;
}

@end
