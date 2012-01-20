//
//  CLLabel.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 20.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLLabel.h"

#define SHADOW_OFFSET CGSizeMake(0,0)
#define SHADOW_AMOUNT 3

@implementation CLLabel

@synthesize glowColor = _glowColor;

- (void)drawTextInRect:(CGRect)rect {
  
  if (_glowColor) {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadow(context, SHADOW_OFFSET, SHADOW_AMOUNT);
    CGContextSetShadowWithColor(context, SHADOW_OFFSET, SHADOW_AMOUNT, _glowColor.CGColor);
    
    [super drawTextInRect:rect];
    
    CGContextRestoreGState(context);
  }
  else {
  
    [super drawTextInRect:rect];
  }    
}

- (void)setGlowColor:(UIColor *)glowColor {

  _glowColor = glowColor;
  [self setNeedsDisplay];
}

@end
