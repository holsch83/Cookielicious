//
//  CLSearchBar.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLSearchBar.h"

@implementation CLSearchBar

/*
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
  
  self.backgroundColor = [UIColor clearColor];
  
  for (UIView *subview in self.subviews) {
    if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")] ||
        [subview isKindOfClass:NSClassFromString(@"UISegmentedControl")]) {
      [subview removeFromSuperview];
    }
  }
}

@end
