//
//  CLResultRecipesController.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecipeView.h"
#import "CLShadowView.h"
#import "CLRecipeDetailView.h"
#import "CLRecipeDetailViewDelegate.h"
#import "CLIngredientCell.h"
#import "ASIHTTPRequest.h"

@interface CLResultRecipesController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate, CLRecipeDetailViewDelegate, ASIHTTPRequestDelegate> {
  // All user selected ingredients
  NSArray *_selectedIngredients;
  
  // The ingredients to filter the recipes by
  NSMutableArray *_currSelectedIngredients;
  
  UIView *_selectedCellBackgroundView;
  
  CGPoint _currRecipeCenterPoint;
  
  CLRecipeView *_currRecipeView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *recipeGridView;
@property (strong, nonatomic) IBOutlet UIView *flipView;
@property (strong, nonatomic) IBOutlet CLShadowView *shadowView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CLRecipeDetailView *recipeDetailView;
@property (strong, nonatomic) CLIngredientCell *ingredientCell;
@property (strong, nonatomic) NSMutableArray *recipes;

- (id) initWithIngredients:(NSArray *)ingredients;

@end
