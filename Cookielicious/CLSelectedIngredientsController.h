//
//  CLSelectedIngredientsController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#define MAX_DRAG_VIEWS 7

#import <UIKit/UIKit.h>
#import "CLSelectedIngredientsDelegate.h"

@class CLDragView;

@interface CLSelectedIngredientsController : UIViewController <UIGestureRecognizerDelegate> {
  
  @private
  NSMutableArray *_uiViews;
  NSMutableArray *_selectedIngredients;
  
  UIPinchGestureRecognizer *_pinchGestureRecognizer;
  UIRotationGestureRecognizer *_rotationGestureRecognizer;
  
  float _radius;
  float _rotation;

}
@property (nonatomic, assign) id<CLSelectedIngredientsDelegate> delegate;

- (BOOL)addIngredientWithView:(CLDragView*)view;
- (void)removeIngredientWithView:(CLDragView*)view;
- (void)removeAllIngredients;
- (BOOL)isDragViewLimitReached;
- (NSArray*)selectedIngredients;

@end
