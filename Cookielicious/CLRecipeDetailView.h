//
//  CLRecipeDetailView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 09.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecipeDetailViewDelegate.h"

@class CLRecipeDetailView;
@class CLRecipe;

@protocol CLRecipeDetailDelegate <NSObject>

- (void)recipeDetailView:(CLRecipeDetailView*)recipeDetailView didSelectShowRecipeWithRecipe:(CLRecipe*)recipe;

@end

@interface CLRecipeDetailView : UIView <UIGestureRecognizerDelegate> {
  UITapGestureRecognizer *tapGestureRecognizer;
  CLRecipe *_recipe;
}

@property (nonatomic, assign) id<CLRecipeDetailDelegate> delegate;
@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *preparationTimeLabel;
@property(nonatomic, strong) IBOutlet UITextView *ingredientsTextView;
@property(nonatomic, strong) IBOutlet UITextView *descriptionTextView;
@property(nonatomic, strong) IBOutlet UIButton *showRecipe;

- (void) configureView:(CLRecipe *)recipeVal;
- (void) touchedView:(id)sender;

@end
