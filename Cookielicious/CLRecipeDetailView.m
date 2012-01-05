//
//  CLRecipeDetailView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 09.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLRecipeDetailView.h"
#import "CLStepIngredient.h"

@interface CLRecipeDetailView (Private)

- (IBAction)touchedShowRecipeButton:(id)sender;

@end

@implementation CLRecipeDetailView

@synthesize delegate = _delegate;
@synthesize imageView = _imageView;
@synthesize titleLabel = _titleLabel;
@synthesize preparationTimeLabel = _preparationTimeLabel;
@synthesize ingredientsTextView = _ingredientsTextView;
@synthesize descriptionTextView = _descriptionTextView;
@synthesize showRecipe = _showRecipe;

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

#pragma mark - View configuration

- (void) configureView:(CLRecipe *)recipeVal {
  _recipe = recipeVal;
  [[self imageView] setImage:[recipeVal image]];
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
  
  // Calculate frame size
//  int ingredientTextViewBottomY = _ingredientsTextView.bounds.size.height - _ingredientsTextView.contentSize.height;
//  int descriptionTextViewBottomY = _descriptionTextView.bounds.size.height - _descriptionTextView.contentSize.height;
//
//  int containerHeight;
//  if(ingredientTextViewBottomY > descriptionTextViewBottomY) {
//    containerHeight = _descriptionTextView.bounds.size.height - descriptionTextViewBottomY;
//  }
//  else {
//    containerHeight = _ingredientsTextView.bounds.size.height - ingredientTextViewBottomY;
//  }
//  
//  self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, containerHeight);
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
