//
//  CLRecipeDetailView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 09.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLRecipeDetailView.h"
#import "CLStepIngredient.h"
#import "CLFavoritesController.h"
#import "SHK.h"

@interface CLRecipeDetailView (Private)

- (IBAction)touchedShowRecipeButton:(id)sender;
- (IBAction)touchedShareButton:(id)sender;
- (IBAction)touchedFavoriteButton:(id)sender;

@end

@implementation CLRecipeDetailView

@synthesize delegate = _delegate;
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize preparationTimeLabel = _preparationTimeLabel;
@synthesize ingredientsTextView = _ingredientsTextView;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize showRecipe = _showRecipe;
@synthesize shareRecipe = _shareRecipe;
@synthesize favoriteRecipe = _favoriteRecipe;

#pragma mark - Object initialization

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchedView:)];
    [tapGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:tapGestureRecognizer];
  }
  return self;
}

#pragma mark - Actions
- (void) touchedView:(id)sender {
  if(_delegate != nil && [_delegate respondsToSelector:@selector(hideRecipeDetailView)]) {
    [_delegate performSelector:@selector(hideRecipeDetailView)];
  }
}

- (IBAction)touchedShowRecipeButton:(id)sender {
  [_delegate recipeDetailView:self didSelectShowRecipeWithRecipe:_recipe];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
  if(touch.view == self) {
    return YES;
  }
  
  return NO;
}

- (IBAction)touchedShareButton:(id)sender {
  
  NSLog(@"Sharing Recipe ...");
  
  // Create the item to share (in this example, a url)
  NSString *shareText = [NSString stringWithFormat:@"Tolles Rezept bei Cookielicious: \"%@\"! Mjamm, klingt das nicht lecker!?", _recipe.title];
  SHKItem *item = [SHKItem text:shareText];
  
  // Get the ShareKit action sheet
  SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
  
  // Display the action sheet
  [actionSheet showFromRect:_shareRecipe.frame inView:self animated:YES];

}

- (IBAction)touchedFavoriteButton:(id)sender {
  if(! [[CLFavoritesController shared] isRecipeFavorite:_recipe]) {
    [[CLFavoritesController shared] addFavoriteWithRecipe:_recipe];
    
    [[self favoriteRecipe] setImage:[UIImage imageNamed:@"icon_heart_faved.png"] forState:UIControlStateNormal];
  }
  else {
    [[CLFavoritesController shared] removeFavoriteWithRecipe:_recipe];
    
    [[self favoriteRecipe] setImage:[UIImage imageNamed:@"icon_heart.png"] forState:UIControlStateNormal];
  }
}

#pragma mark - View configuration

- (void) configureView:(CLRecipe *)recipeVal {
  _recipe = recipeVal;
  [[self imageView] setImageWithUrlString:[recipeVal image]];
  [[self titleLabel] setText:[recipeVal title]];
  [[self preparationTimeLabel] setText:[NSString stringWithFormat:@"%d Min.",[recipeVal preparationTime]]];
  
  // Set ingredients as bulleted list
  NSMutableString *ingredientString = [[NSMutableString alloc] init];
  for(CLStepIngredient *ingr in [recipeVal ingredients]) {
    // Only display decimal if number is not natural
    if([ingr amount] == 0) {
      [ingredientString appendFormat:@"\u2022 %@\n",[ingr name]];
    }
    else if([ingr amount] == floor([ingr amount])) {
      [ingredientString appendFormat:@"\u2022 %.0f %@\t%@\n",[ingr amount],[ingr unit],[ingr name]];
    }
    else {
      [ingredientString appendFormat:@"\u2022 %.02f %@\t%@\n",[ingr amount],[ingr unit],[ingr name]];
    }
  }
  [[self ingredientsTextView] setText:ingredientString];
  
  if([[CLFavoritesController shared] isRecipeFavorite:recipeVal]) {
    [[self favoriteRecipe] setImage:[UIImage imageNamed:@"icon_heart_faved.png"] forState:UIControlStateNormal];
  }
  else {
    [[self favoriteRecipe] setImage:[UIImage imageNamed:@"icon_heart.png"] forState:UIControlStateNormal];
  }
}

#pragma mark - Custom drawing

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  CGContextRef currentContext = UIGraphicsGetCurrentContext();
  CGContextSaveGState(currentContext);
  CGContextSetShadow(currentContext, CGSizeMake(0, 0), 5);
  
  // draw the rect
  CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height - 20);
  CGContextSetRGBFillColor(currentContext, 255, 255, 255, 1);
  CGContextFillRect(currentContext, newRect);
  
  CGContextRestoreGState(currentContext);
}

@end
