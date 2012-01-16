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
  NSMutableArray *_currSelectedIngredients;
  CLRecipeView *_currRecipeView;
  UIView *_selectedCellBackgroundView;
  CGPoint _currRecipeCenterPoint;
}

@property (strong, nonatomic) IBOutlet UIScrollView *recipeGridView;
@property (strong, nonatomic) IBOutlet UIView *flipView;
@property (strong, nonatomic) IBOutlet CLShadowView *shadowView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) CLRecipeDetailView *recipeDetailView;
@property (strong, nonatomic) CLIngredientCell *ingredientCell;
@property (strong, nonatomic) NSMutableArray *recipes;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;



@end
