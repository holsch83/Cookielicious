//
//  CLRecipeDetailViewDelegate.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClRecipeView.h"

@class CLRecipe;
@class CLRecipeView;
@class CLRecipeDetailView;

@protocol CLRecipeDetailViewDelegate <NSObject>

- (void)showRecipeDetailView:(CLRecipeView *)viewVal;
- (void)hideRecipeDetailView;
- (void)recipeDetailView:(CLRecipeDetailView*)recipeDetailView didSelectShowRecipeWithRecipe:(CLRecipe*)recipe;


@end
