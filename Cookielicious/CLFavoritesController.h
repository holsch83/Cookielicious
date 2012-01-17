//
//  CLFavoritesController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 16.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

@class CLRecipe;
@class CLFavoritesController;

@protocol CLFavoritesDelegate <NSObject>

- (void)favoritesController:(CLFavoritesController*)controller didSelectFavoriteWithRecipe:(CLRecipe*)recipe;

@end


@interface CLFavoritesController : UITableViewController <NSFetchedResultsControllerDelegate>{

  NSManagedObjectContext *_managedObjectContext;
  
}

@property (nonatomic, assign) id <CLFavoritesDelegate> delegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

/**
 Class method to access the Favorite controller as singleton
 */
+ (CLFavoritesController*)shared;

/**
 Adds a recipes id, title and image to core data. If id already exists in core data,
 the recipe is not being added.
 */
- (void)addFavoriteWithRecipe:(CLRecipe *)recipe;

/**
 Remove a favorite recipe from the core data stack.
 */
- (void)removeFavoriteWithRecipe:(CLRecipe *)recipe;


/**
 Returns a boolean whether a recipe is marked as favorite or not.
 */
- (BOOL)isRecipeFavorite:(CLRecipe*)recipe;

@end
