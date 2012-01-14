//
//  CLRecipeDetailViewDelegate.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLRecipe.h"

@protocol CLRecipeDetailViewDelegate <NSObject>

- (void)showRecipeDetailView:(UIView *)viewVal;
- (void)hideRecipeDetailView;
- (void)recipeDetailView:(UIView *)recipeDetailView didSelectShowRecipeWithRecipe:(CLRecipe*)recipe;

@end
