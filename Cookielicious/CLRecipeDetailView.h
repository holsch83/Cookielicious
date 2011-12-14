//
//  CLRecipeDetailView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 09.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecipe.h"

@interface CLRecipeDetailView : UIView

@property(nonatomic, strong) IBOutlet UIImageView *imageView;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *preparationTimeLabel;
@property(nonatomic, strong) IBOutlet UITextView *ingredientsTextView;
@property(nonatomic, strong) IBOutlet UITextView *descriptionTextView;

- (void) configureView:(CLRecipe *)recipeVal;

@end
