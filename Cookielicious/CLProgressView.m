//
//  CLProgressView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 23.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLProgressView.h"

#define kCustomProgressViewFillOffsetX 3
#define kCustomProgressViewFillOffsetTopY 2
#define kCustomProgressViewFillOffsetBottomY 2
#define CL_PROGRESSVIEW_FILL_MINWIDTH 7

@implementation CLProgressView

- (void)drawRect:(CGRect)rect {
  CGSize backgroundStretchPoints = {4, 5}, fillStretchPoints = {3, 3};
  
  // Initialize the stretchable images.
  UIImage *background = [[UIImage imageNamed:@"progressview_bar.png"] stretchableImageWithLeftCapWidth:backgroundStretchPoints.width 
                                                                                         topCapHeight:backgroundStretchPoints.height];
  
  UIImage *fill = [[UIImage imageNamed:@"progressview_progress.png"] stretchableImageWithLeftCapWidth:fillStretchPoints.width 
                                                                                     topCapHeight:fillStretchPoints.height];  
  
  // Draw the background in the current rect
  [background drawInRect:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, background.size.height)];
  
  // Compute the max width in pixels for the fill.  Max width being how
  // wide the fill should be at 100% progress.
  NSInteger maxWidth = rect.size.width - (2 * kCustomProgressViewFillOffsetX) - CL_PROGRESSVIEW_FILL_MINWIDTH;
  
  // Compute the width for the current progress value, 0.0 - 1.0 corresponding 
  // to 0% and 100% respectively.
  NSInteger curWidth = floor([self progress] * maxWidth) + CL_PROGRESSVIEW_FILL_MINWIDTH;
  
  // Create the rectangle for our fill image accounting for the position offsets,
  // 1 in the X direction and 1, 3 on the top and bottom for the Y.
  CGRect fillRect = CGRectMake(rect.origin.x + kCustomProgressViewFillOffsetX,
                               rect.origin.y + kCustomProgressViewFillOffsetTopY,
                               curWidth,
                               fill.size.height);
  
  // Draw the fill
  [fill drawInRect:fillRect];
}

@end
