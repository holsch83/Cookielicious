//
//  CLSetTimerDelegate.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLStepViewDelegate <NSObject>

- (void) setTimer:(NSString *)timerName duration:(NSNumber *)duration;

@end
