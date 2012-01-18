//
//  CLSelectedIngredientsController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#define MAX_DRAG_VIEWS 14

#import <UIKit/UIKit.h>
#import "CLSelectedIngredientsDelegate.h"

@class CLDragView;

@interface CLSelectedIngredientsController : UIViewController {
  
  @private
  NSMutableArray *_uiViews;
  NSMutableArray *_selectedIngredients;

}
@property (nonatomic, assign) id<CLSelectedIngredientsDelegate> delegate;
@property (nonatomic, strong) IBOutlet UILabel *selectedCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *maxCountLabel;

- (BOOL)addIngredientWithView:(CLDragView*)view;
- (void)removeIngredientWithView:(CLDragView*)view;
- (void)removeAllIngredients;
- (BOOL)isDragViewLimitReached;
- (NSArray*)selectedIngredients;

@end
