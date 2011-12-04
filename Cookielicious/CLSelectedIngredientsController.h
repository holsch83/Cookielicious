//
//  CLSelectedIngredientsController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLDragView;

@interface CLSelectedIngredientsController : UIViewController {

  @private
  NSMutableArray *_uiViews;

}

- (BOOL)addIngredientWithView:(CLDragView*)view;
- (void)removeIngredientWithView:(CLDragView*)view;

@end
