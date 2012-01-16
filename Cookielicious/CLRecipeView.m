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
@synthesize ingredientsLabel = _ingredientsLabel;
@synthesize imageView = _imageView;
@synthesize recipe = _recipe;
@synthesize delegate = _delegate;

- (void) configureView:(CLRecipe *)recipe {
  NSString *ingredientString = [recipe ingredientsWithSeparator:@", "];
  [self.titleLabel setText:[recipe title]];
  [self.ingredientsLabel setText:ingredientString];
  [self.imageView setImageWithUrlString:[recipe image]];
  [self setRecipe:recipe];
  
  CGSize maximumSize = CGSizeMake(self.ingredientsLabel.bounds.size.width, self.ingredientsLabel.bounds.size.height);
  UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:13];
  CGSize labelStringSize = [ingredientString sizeWithFont:labelFont 
                                       constrainedToSize:maximumSize 
                                           lineBreakMode:self.ingredientsLabel.lineBreakMode];
  
  int x = self.titleLabel.frame.origin.x;
  int y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 5;
  
  CGRect labelFrame = CGRectMake(x, y, self.ingredientsLabel.bounds.size.width, labelStringSize.height);
  
  self.ingredientsLabel.frame = labelFrame;
}

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
  CGContextSetShadow(currentContext, CGSizeMake(0, 0), 8);
  
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
