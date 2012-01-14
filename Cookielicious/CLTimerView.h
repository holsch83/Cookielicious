//
//  CLTimerView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTimerViewDelegate.h"

@interface CLTimerView : UIView {
  UITapGestureRecognizer *_tapGestureRecognizer;
}

@property(nonatomic, assign) id<CLTimerViewDelegate> delegate;
@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) IBOutlet UILabel *timerNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *timeLeftLabel;

- (void) touchedView;
- (void) updateTimer:(NSTimer *)theTimer;

@end
