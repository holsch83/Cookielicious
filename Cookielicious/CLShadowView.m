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
    [_tapGestureRecognizer setDelegate:self];
    
    //[self addGestureRecognizer:_tapGestureRecognizer];
  }
  return self;
}

#pragma mark - Touch events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [self hideView];
}

- (void) hideView {
  if([delegate respondsToSelector:@selector(hideRecipeDetailView)]) {
    [delegate performSelector:@selector(hideRecipeDetailView)];
  }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  NSLog(@"View: %@", [touch.view class]);
  
  if([touch.view isKindOfClass:NSClassFromString(@"UIButton")]) {
    return NO;
  }
  
  return YES;
}

@end
