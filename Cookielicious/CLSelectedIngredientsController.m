//
//  CLSelectedIngredientsController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLAppDelegate.h"
#import "CLSelectedIngredientsController.h"
#import "CLIngredient.h"
#import "CLDragView.h"

#define CL_RADIUS_MAX 240.0

@interface CLSelectedIngredientsController(Private)

- (void) pinchedView:(UIGestureRecognizer *)gestureRecognizer;
- (void) rotatedView:(UIGestureRecognizer *)gestureRecognizer;
- (void) reorderDragViews;
- (void) reorderDragViewsAnimated:(BOOL)animated;
- (void) resetDragViewsAnimated:(BOOL)animated;

- (float) radius;

@end

@implementation CLSelectedIngredientsController

@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      
    _uiViews = [[NSMutableArray alloc] init];
    _selectedIngredients = [[NSMutableArray alloc] init];
    self.view.clipsToBounds = NO;
    
    _radius = 0.0;
    _rotation = M_PI_2;
    
    _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                        action:@selector(pinchedView:)];
    [_pinchGestureRecognizer setCancelsTouchesInView:NO];
    [_pinchGestureRecognizer setDelaysTouchesEnded:NO];
    [_pinchGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:_pinchGestureRecognizer];
    
    _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(rotatedView:)];
    [_rotationGestureRecognizer setCancelsTouchesInView:NO];
    [_rotationGestureRecognizer setDelaysTouchesEnded:NO];
    [_rotationGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:_rotationGestureRecognizer];
  }
  return self;
}

#pragma mark - Action handlers

- (void)removeIngredientWithView:(CLDragView*)view {
  
  CLIngredient *ingr = view.ingredient;
  
  [UIView animateWithDuration:0.2 animations:^{
    [view setAlpha:0];
  } completion:^(BOOL finished){
    [_uiViews removeObjectIdenticalTo:view];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIngredientsController:didRemoveIngredient:)]) {
      [_delegate performSelector:@selector(selectedIngredientsController:didRemoveIngredient:) 
                      withObject:self 
                      withObject:ingr];
    }
    
    [view removeFromSuperview];
    
    _radius = [self radius];
    
    [self reorderDragViewsAnimated:YES];
  }];
}

- (void)removeAllIngredients {
  
  NSMutableArray *removedIngredients = [[NSMutableArray alloc] init];
  
  [UIView animateWithDuration:0.2 animations:^{
    for (CLDragView *view in _uiViews) {
      [view setAlpha:0];
    }
  } completion:^(BOOL finished){
    for (CLDragView *view in _uiViews) {
      [removedIngredients addObject:view.ingredient];
      [view removeFromSuperview];
    }
    
    [_uiViews removeAllObjects];
    
    _radius = 0.0;
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIngredientsController:didRemoveAllIngredients:)]) {
      [_delegate performSelector:@selector(selectedIngredientsController:didRemoveAllIngredients:) 
                      withObject:self 
                      withObject:removedIngredients];
    }

  }];
  
  
  
}

- (BOOL)addIngredientWithView:(CLDragView*)view {
  
  CGPoint centerPoint = CGPointMake(ceil(view.frame.size.width/2) - 30, 
                                    ceil(view.frame.size.height/2) - 30);
  
  CGPoint currentPosition = [view convertPoint:centerPoint toView:self.view];
  
  if(! [_uiViews containsObject:view] && [_uiViews count] < MAX_DRAG_VIEWS) {
    
    view.center = currentPosition;
    view.gestureRecognizers = nil;
    
    [_uiViews addObject:view];
    [self.view addSubview:view];
    
    if (_delegate && [_delegate respondsToSelector:@selector(selectedIngredientsController:didAddIngredient:)]) {
      [_delegate performSelector:@selector(selectedIngredientsController:didAddIngredient:) 
                      withObject:self 
                      withObject:view.ingredient];
    }
    _radius = [self radius];
    
    [self reorderDragViewsAnimated:YES];

    return YES;
  }
  else {
    return NO;
  }
}

- (BOOL)isDragViewLimitReached {

  return (([_uiViews count] == MAX_DRAG_VIEWS) ? YES : NO);
}

- (NSArray*)selectedIngredients {
  
  NSMutableArray *array = [[NSMutableArray alloc] init];
  for (CLDragView *dv in _uiViews) {
    [array addObject:dv.ingredient];
  }
  return array;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

#pragma mark - Private

- (void) pinchedView:(UIPinchGestureRecognizer *)gestureRecognizer {
  if([_uiViews count] < 2) {
    return;
  }
  
  UIGestureRecognizerState state = gestureRecognizer.state;
  switch (state) {
    case UIGestureRecognizerStateChanged:
      _radius = [self radius] * gestureRecognizer.scale;
      if(_radius > CL_RADIUS_MAX) {
        _radius = CL_RADIUS_MAX;
      }
      
      [self reorderDragViewsAnimated:NO];
      break;
      
    case UIGestureRecognizerStateEnded:
      [self resetDragViewsAnimated:YES];
      break;
      
    default:
      break;
  }
}

- (void) rotatedView:(UIRotationGestureRecognizer *)gestureRecognizer {
  if([_uiViews count] < 2) {
    return;
  }
  
  UIGestureRecognizerState state = gestureRecognizer.state;
  switch(state) {
    case UIGestureRecognizerStateChanged:
      _rotation = M_PI_2 - gestureRecognizer.rotation;
      [self reorderDragViewsAnimated:NO];
      break;
      
    case UIGestureRecognizerStateEnded:
      [self resetDragViewsAnimated:YES];
      break;
      
    default:
      break;
  }
}

- (void) reorderDragViews {
  // Reorder all uiView items. The radius of the circle is based
  // on the amount of items in the array.
  float radius = _radius;
  CGPoint circleCenter = [self.view center];
  for (int i = 1, j = [_uiViews count]; i <= j; i++) {
    UIView *currView = [_uiViews objectAtIndex:i - 1];
    
    // We need to calculate the angle for the current item in the circle.
    // A circle has a radius of 2*M_PI and we rotate it 90 deg (M_PI_2) anticlockwise,
    // so the first item in an new array is positioned at 90 deg.
    // If there is more than one item in the array, we split the circle
    // in j parts (the amount of items) and evety item is rotated +1 of
    // those parts.
    float currAngleRad = ((float)i / (float)j) * (2 * M_PI) - _rotation;
    
    // Get the dx and dy values for the current items angle.
    float dx = radius * cos(currAngleRad);
    float dy = radius * sin(currAngleRad);
    
    // Add dx and dy to the center of the circle, thus placing
    // the current item on the outer circle on its calculated position.
    float newX = circleCenter.x + dx;
    float newY = circleCenter.y + dy;
    
    // Weird.
    currView.center = CGPointMake(newX, newY);
  }
}

- (void)reorderDragViewsAnimated:(BOOL)animated {
  if(animated) {
    [UIView animateWithDuration:0.5 animations:^{
      [self reorderDragViews];
    } completion:^(BOOL finished) {
      // New items are made transparent. After reordering the existing items,
      // we need to fade in the new item.
      [UIView animateWithDuration:0.4 animations:^{
        for(int i = 0, j = [_uiViews count]; i < j; i++) {
          UIView *currView = [_uiViews objectAtIndex:i];
          
          [currView setAlpha:1];
        }
      }];
    }];
  }
  else {
    [self reorderDragViews];
  }
}

- (void)resetDragViewsAnimated:(BOOL)animated {
  _radius = [self radius];
  _rotation = M_PI_2;
  
  [self reorderDragViewsAnimated:animated];
}

- (float) radius {
  return (100 + (50 * ([_uiViews count] / 4 )));
}

@end
