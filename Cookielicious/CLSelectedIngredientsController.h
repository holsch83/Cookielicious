//
//  CLSelectedIngredientsController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#define MAX_DRAG_VIEWS 5

#import <UIKit/UIKit.h>

@class CLDragView;

@interface CLSelectedIngredientsController : UIViewController {

  @private
  NSMutableArray *_uiViews;

}

- (BOOL)addIngredientWithView:(CLDragView*)view;
- (void)removeIngredientWithView:(CLDragView*)view;
- (BOOL)isDragViewLimitReached;

@end
