//
//  CLSelectedIngredientsController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLSelectedIngredientsController.h"
#import "CLDragView.h"

@interface CLSelectedIngredientsController(Private)

- (void)reorderDragViews;

@end

@implementation CLSelectedIngredientsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      
    _uiViews = [[NSMutableArray alloc] init];
    self.view.clipsToBounds = NO;
  }
  return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
}

#pragma mark - Action handlers

- (void)removeIngredientWithView:(CLDragView*)view {
    
  [UIView animateWithDuration:0.2 animations:^{
    [view setAlpha:0];
  } completion:^(BOOL finished){
    [_uiViews removeObjectIdenticalTo:view];
    [view removeFromSuperview];
    [self reorderDragViews];
  }];
  
  NSLog(@"Items left in array: %d", [_uiViews count]);
}

- (BOOL)addIngredientWithView:(CLDragView*)view {
  
  CGPoint centerPoint = CGPointMake(ceil(view.frame.size.width/2), 
                                    ceil(view.frame.size.height/2));
  
  CGPoint currentPosition = [view convertPoint:centerPoint toView:self.view];
  
  if(! [_uiViews containsObject:view] && [_uiViews count] < MAX_DRAG_VIEWS) {
    
    view.center = currentPosition;
    view.gestureRecognizers = nil;
    
    [_uiViews addObject:view];
    [self.view addSubview:view];
    
    [self reorderDragViews];
    
    return YES;
  }
  else {

    return NO;
  }
}

- (BOOL)isDragViewLimitReached {

  return (([_uiViews count] == MAX_DRAG_VIEWS) ? YES : NO);
}

#pragma mark - Private

- (void)reorderDragViews {
  [UIView animateWithDuration:0.5 animations:^{
    // Reorder all uiView items. The radius of the circle is based
    // on the amount of items in the array.
    float radius = (100 + (50 * ([_uiViews count] / 4 )));
    CGPoint circleCenter = [self.view center];
    for (int i = 1, j = [_uiViews count]; i <= j; i++) {
      UIView *currView = [_uiViews objectAtIndex:i - 1];
      
      // We need to calculate the angle for the current item in the circle.
      // A circle has a radius of 2*M_PI and we rotate it 90 deg (M_PI_2) anticlockwise,
      // so the first item in an new array is positioned at 90 deg.
      // If there is more than one item in the array, we split the circle
      // in j parts (the amount of items) and evety item is rotated +1 of
      // those parts.
      float currAngleRad = ((float)i / (float)j) * (2 * M_PI) - M_PI_2;
      
      // Get the dx and dy values for the current items angle.
      float dx = radius * cos(currAngleRad);
      float dy = radius * sin(currAngleRad);
      
      NSLog(@"dx: %f, dy: %f, i: %d, j: %d, i/j: %f, currAngle: %f", dx, dy, i, j, ((float)i/(float)j), currAngleRad * (180 / M_PI));
      
      // Add dx and dy to the center of the circle, thus placing
      // the current item on the outer circle on its calculated position.
      float newX = circleCenter.x + dx;
      float newY = circleCenter.y + dy;
      
      // Weird.
      currView.center = CGPointMake(newX, newY);
    }
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



@end
