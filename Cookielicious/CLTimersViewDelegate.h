//
//  CLTimersViewDelegate.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 11.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLTimerView.h"

@protocol CLTimersViewDelegate <NSObject>

- (void) deleteTimer:(NSTimer *)theTimer forView:(CLTimerView *)view;

@end
