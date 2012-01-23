//
//  CLSearchBar.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLSearchBar.h"

@implementation CLSearchBar

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if(self) {
    self.frame = CGRectMake(self.frame.origin.x + 7, self.frame.origin.y + 5, 320, self.frame.size.height);
  }
  return self;
}

/**
 * We want a UISearchBar without the "bar"-background.
 * We support iOS 4 so we have only this possibility to remove the
 * background of the searchbar.
 * We check if there are subviews, which are from type UISearchBarBackground and
 * UISegementedControl. If yes, we remove them from superview.
 *
 * WARNING: If Apple changes its SDK, this may does not work.
 * If they rename the classes, the background is visible again. If they just
 * change the view hierarchy, we are safe.
 * In any case, we are crash safe.
 */

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  for (UIView *subview in self.subviews) {
    if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")] ||
        [subview isKindOfClass:NSClassFromString(@"UISegmentedControl")]) {
      [subview removeFromSuperview];
    }
    
    if([subview isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
      [(UITextField *)subview setBackground:[[UIImage imageNamed:@"search_bar.png"] stretchableImageWithLeftCapWidth:25 topCapHeight:17]];
    }
  }
  
  self.backgroundColor = [UIColor clearColor];
}

@end
