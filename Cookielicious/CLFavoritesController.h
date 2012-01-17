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

+ (CLFavoritesController*)shared;

- (void)addFavoriteWithRecipe:(CLRecipe*)recipe;

- (BOOL)isRecipeFavorite:(CLRecipe*)recipe;

@end
