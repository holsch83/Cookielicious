//
//  CLDragViewDelegate.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLDragView;
@class CLIngredient;

@protocol CLDragViewDelegate <NSObject>

- (void)removeDragView:(CLDragView*)dragView withIngredient:(CLIngredient*)ingredient;
- (void)dragView:(CLDragView*)dragView detectedLongPressWithRecognizer:(UILongPressGestureRecognizer*)recognizer;
- (void)dragView:(CLDragView*)dragView detectedTapWithRecognizer:(UITapGestureRecognizer*)recognizer;

@end
