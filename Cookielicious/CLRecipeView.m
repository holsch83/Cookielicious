//
//  CLRecipeView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLRecipeView.h"

@implementation CLRecipeView

@synthesize titleLabel = _titleLabel;
@synthesize ingredientsTextView = _ingredientsTextView;
@synthesize imageView = _imageView;
@synthesize recipe = _recipe;
@synthesize delegate = _delegate;

#pragma mark - User interaction

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if([_delegate respondsToSelector:@selector(showRecipeDetailView:)]) {
    [_delegate performSelector:@selector(showRecipeDetailView:) withObject:self];
  }
}

#pragma mark - Core Grahics

- (void)drawRect:(CGRect)rect {
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(currentContext);
  
  // Corner radius
  int radius = 2;
  int padding = 10;
  
  rect.origin = CGPointMake(rect.origin.x + padding, rect.origin.y + padding);
  rect.size = CGSizeMake(rect.size.width - 2*padding, rect.size.height - 2*padding);
  
  // Set shadow
  CGContextSetShadow(currentContext, CGSizeMake(0, 0), 5);
  
  // draw the rect
  CGContextSetRGBFillColor(currentContext, 255, 255, 255, 1);
  
  CGContextMoveToPoint(currentContext, rect.origin.x, rect.origin.y + radius);
  CGContextAddLineToPoint(currentContext, rect.origin.x, rect.origin.y + rect.size.height - radius);
  CGContextAddArc(currentContext, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, 
                  radius, M_PI, M_PI / 2, 1); //STS fixed
  CGContextAddLineToPoint(currentContext, rect.origin.x + rect.size.width - radius, 
                          rect.origin.y + rect.size.height);
  CGContextAddArc(currentContext, rect.origin.x + rect.size.width - radius, 
                  rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
  CGContextAddLineToPoint(currentContext, rect.origin.x + rect.size.width, rect.origin.y + radius);
  CGContextAddArc(currentContext, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, 
                  radius, 0.0f, -M_PI / 2, 1);
  CGContextAddLineToPoint(currentContext, rect.origin.x + radius, rect.origin.y);
  CGContextAddArc(currentContext, rect.origin.x + radius, rect.origin.y + radius, radius, 
                  -M_PI / 2, M_PI, 1);
  
  CGContextFillPath(currentContext);
  CGContextRestoreGState(currentContext);
}

@end
