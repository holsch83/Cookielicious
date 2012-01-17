//
//  CLButton.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 15.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLButton.h"

#define CL_BUTTON_PATTERN_SIDEWIDTH 15
#define CL_BUTTON_PATTERN_HEIGHT 43

@implementation CLButton

- (id) initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    // As we are supporting iOS 4.3, we need to fall back to this solution
    UIImage *buttonBackground = [[UIImage imageNamed:@"button.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
    [self setBackgroundImage:buttonBackground forState:UIControlStateNormal];
    
    UIImage *buttonSelectedBackground = [[UIImage imageNamed:@"button_selected.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [self setBackgroundImage:buttonSelectedBackground forState:UIControlStateHighlighted];
  }
  return self;
}

/*
- (void)drawRect:(CGRect)rect {
  float offsetY = (rect.size.height - CL_BUTTON_PATTERN_HEIGHT) / 2;
  
  CGRect buttonLeftRect = CGRectMake(0, offsetY, CL_BUTTON_PATTERN_SIDEWIDTH, CL_BUTTON_PATTERN_HEIGHT);
  CGRect buttonRightRect = CGRectMake(rect.size.width - CL_BUTTON_PATTERN_SIDEWIDTH, offsetY, CL_BUTTON_PATTERN_SIDEWIDTH, CL_BUTTON_PATTERN_HEIGHT);
  CGRect buttonBackgroundRect = CGRectMake(CL_BUTTON_PATTERN_SIDEWIDTH, offsetY, rect.size.width - 2*CL_BUTTON_PATTERN_SIDEWIDTH, CL_BUTTON_PATTERN_HEIGHT);
  
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(currentContext);
  
  // Define patterns
  UIColor *buttonBackgroundLeft = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_left.png"]];
  UIColor *buttonBackgroundRight = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_right.png"]];
  UIColor *buttonBackground = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button_bg.png"]];
  
  // Draw left side
  CGContextSetFillColorWithColor(currentContext, [buttonBackgroundLeft CGColor]);
  CGContextFillRect(currentContext, buttonLeftRect);
  
  // Draw right side
  CGContextSetFillColorWithColor(currentContext, [buttonBackgroundRight CGColor]);
  CGContextFillRect(currentContext, buttonRightRect);
  
  // Draw center
  CGContextSetFillColorWithColor(currentContext, [buttonBackground CGColor]);
  CGContextFillRect(currentContext, buttonBackgroundRect);
  
  CGContextRestoreGState(currentContext);
}*/

@end
