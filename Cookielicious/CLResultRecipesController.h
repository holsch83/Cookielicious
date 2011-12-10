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

@protocol CLRecipeDetailViewDelegate <NSObject>

- (void) showRecipeDetailView:(NSObject *)recipeVal forView:(CLRecipeView *)viewVal;
- (void) hideRecipeDetailView;

@end

@interface CLResultRecipesController : UIViewController <NSFetchedResultsControllerDelegate, CLRecipeDetailViewDelegate> {
    CLRecipeView *currRecipeView;
    CGPoint currRecipeCenterPoint;
}

@property (strong, nonatomic) IBOutlet UIScrollView *recipeGridView;
@property (strong, nonatomic) IBOutlet UIView *flipView;
@property (strong, nonatomic) IBOutlet CLShadowView *shadowView;
@property (strong, nonatomic) CLRecipeDetailView *recipeDetailView;


@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;

@end
