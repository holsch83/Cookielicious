//
//  CLTimerViewDelegate.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 11.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLTimerViewDelegate <NSObject>

- (void) touchedTimerView:(UIView *)theView;
- (void) timerFinished:(NSTimer *)theTimer forView:(UIView *)theView;

@end
