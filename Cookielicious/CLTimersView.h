//
//  CLTimersView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTimerView.h"
#import "CLTimerViewDelegate.h"
#import "CLTimersViewDelegate.h"
#import "CLTimerPopoverViewControllerDelegate.h"

@interface CLTimersView : UIView<CLTimerViewDelegate, CLTimerPopoverViewControllerDelegate> {
  float _currOffset;
  
  CLTimerView *_currSelectedTimerView;
  UIPopoverController *_popoverController;
}

@property(nonatomic, assign) id<CLTimersViewDelegate> delegate;

- (void)reorderSubviews;

@end
