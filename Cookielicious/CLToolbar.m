//
//  CLToolbar.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 17.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLToolbar.h"

@implementation CLToolbar

- (id)initWithFrame:(CGRect)frame {

  if (self = [super initWithFrame:frame]) {
    
    self.backgroundColor = [UIColor clearColor];
    self.tintColor = [UIColor colorWithRed:60.0/255.0 green:20.0/255.0 blue:0.0/255.0 alpha:1.0];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {

  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(currentContext);
  CGContextClearRect(currentContext, rect);
  CGContextRestoreGState(currentContext);
}

@end
