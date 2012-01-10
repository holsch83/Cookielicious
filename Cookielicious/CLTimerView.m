//
//  CLTimerView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLTimerView.h"

@implementation CLTimerView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if(self) {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedView)];
  }
  return self;
}

- (void) touchedView {
  NSLog(@"Touched timer view");
}

@end
