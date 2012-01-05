//
//  CLCookRecipeController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLStepView;
@class CLRecipe;

@interface CLCookRecipeController : UIViewController {

  IBOutlet UIScrollView *_scrollView;
  IBOutlet CLStepView *_stepView;
  CLRecipe *_recipe;
  
}

- (id)initWithRecipe:(CLRecipe*)recipe;

@end
