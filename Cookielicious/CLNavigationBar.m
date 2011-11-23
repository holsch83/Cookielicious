//
//  CLNavigationBar.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

#define MAIN_COLOR_COMPONENTS             { 1.0, 1.0, 0.78, 1.0, 1.0, 1.0, 0.78, 1.0 }
#define BOTTOMLINE_COLOR_COMPONENTS       { 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0 }

@interface CLNavigationBar (Private)

- (void)applyShadow;

@end

@implementation CLNavigationBar

- (void)drawRect:(CGRect)rect {
  
//  CGContextRef context = UIGraphicsGetCurrentContext();
//  CGFloat locations[2] = { 0.0, 1.0 };
//  CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
//  
//  CGFloat topComponents[8] = MAIN_COLOR_COMPONENTS;
//  CGGradientRef topGradient = CGGradientCreateWithColorComponents(myColorspace, topComponents, locations, 2);
//  CGContextDrawLinearGradient(context, topGradient, CGPointMake(0, 0), CGPointMake(0,self.frame.size.height-3), 0);
//  CGGradientRelease(topGradient);
//  
//  CGFloat botComponents[8] = BOTTOMLINE_COLOR_COMPONENTS;
//  CGGradientRef botGradient = CGGradientCreateWithColorComponents(myColorspace, botComponents, locations, 2);
//  CGContextDrawLinearGradient(context, botGradient,
//                              CGPointMake(0,self.frame.size.height-3), CGPointMake(0, self.frame.size.height), 0);
//  CGGradientRelease(botGradient);
//  
//  CGColorSpaceRelease(myColorspace);
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGColorRef fillColor = 
  [[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern_navigationbar.png"]] CGColor];
  CGContextSetFillColorWithColor(context, fillColor);
  CGContextFillRect(context, self.bounds);
  
  self.tintColor = [UIColor blackColor];
  
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
  [super willMoveToWindow:newWindow];
  [self applyShadow];
}

- (void)applyShadow {
  // add the drop shadow
  self.layer.shadowColor = [[UIColor blackColor] CGColor];
  self.layer.shadowOffset = CGSizeMake(0.0, 3);
  self.layer.shadowRadius = 10.0;
  self.layer.shadowOpacity = 1.0;
  self.layer.masksToBounds = NO;
  self.layer.shouldRasterize = YES;
}

@end
