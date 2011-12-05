//
//  CLSelectedIngredientsController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 03.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#define MAX_DRAG_VIEWS 8

#import <UIKit/UIKit.h>

@class CLDragView;

@interface CLSelectedIngredientsController : UIViewController {

  @private
  NSMutableArray *_uiViews;

}

@property (strong, nonatomic) IBOutlet UILabel *selectedCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *maxCountLabel;

- (BOOL)addIngredientWithView:(CLDragView*)view;
- (void)removeIngredientWithView:(CLDragView*)view;
- (BOOL)isDragViewLimitReached;

@end
