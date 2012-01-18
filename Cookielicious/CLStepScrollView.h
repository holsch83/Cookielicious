//
//  CLStepScrollView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 18.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLStepScrollView : UIScrollView {
  UITapGestureRecognizer *_tapGestureRecognizer;
}

- (void)touchedView:(UIGestureRecognizer *)gestureRecognizer;

- (BOOL) hasPreviousPage;
- (BOOL) hasNextPage;

- (void) scrollToPreviousPageAnimated:(BOOL)animated;
- (void) scrollToNextPageAnimated:(BOOL)animated;

- (int) currentPage;
@end
