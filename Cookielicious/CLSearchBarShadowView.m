//
//  CLSearchBarShadowView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 19.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLSearchBarShadowView.h"

@implementation CLSearchBarShadowView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
      // Initialization code
    self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + 10, frame.size.height);
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  CGRect newRect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width - 10, rect.size.height);
  CGSize offset = CGSizeMake(5.0, 0.0);
  float blur = 5.0;
  
  // Drawing code
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(currentContext);
  
  // Add drop shadow
  CGContextSetShadow(currentContext, offset, blur);

  // Add wooden pattern
  UIColor *pattern = [UIColor colorWithPatternImage:[UIImage imageNamed:@"leatherbook.png"]];
  //UIColor *pattern = [UIColor colorWithRed:1 green:1 blue:(198.0/255.0) alpha:1];
  CGContextSetFillColorWithColor(currentContext, [pattern CGColor]);
  CGContextFillRect(currentContext, newRect);
  
  CGContextRestoreGState(currentContext);
}


@end
