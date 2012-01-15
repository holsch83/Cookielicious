//
//  CLRecipeView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CLRecipe.h"
#import "CLAsyncImageView.h"
#import "CLRecipeDetailViewDelegate.h"

@interface CLRecipeView : UIView 

@property(nonatomic, assign) id <CLRecipeDetailViewDelegate> delegate;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;
@property(nonatomic, strong) IBOutlet UILabel *ingredientsLabel;
@property(nonatomic, strong) IBOutlet CLAsyncImageView *imageView;
@property(nonatomic, strong) CLRecipe *recipe;

- (void) configureView:(CLRecipe *)recipe;

@end
