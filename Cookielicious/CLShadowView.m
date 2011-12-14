//
//  CLFlipView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLShadowView.h"

@interface CLShadowView (Private)

- (void) hideView;

@end

@implementation CLShadowView

@synthesize delegate;

- (id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self addGestureRecognizer:_tapGestureRecognizer];
  }
  return self;
}

#pragma mark - Touch events

- (void) hideView {
  if([delegate respondsToSelector:@selector(hideRecipeDetailView)]) {
    [delegate performSelector:@selector(hideRecipeDetailView)];
  }
}

@end
