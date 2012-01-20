//
//  CLIngredientCell.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLIngredient.h"
#import "CLMainViewController.h"
#import "CLIngredientCell.h"
#import "CLDragView.h"

@implementation CLIngredientCell

@synthesize ingredientLabel = _ingredientLabel;
@synthesize ingredient = _ingredient;
@synthesize rootController = _rootController;

- (NSString*)reuseIdentifier {
  return @"IngredientCell";
}

- (id)initWithCoder:(NSCoder *)aDecoder {

  self = [super initWithCoder:aDecoder];
  if (self) {
    _checkmark = 
    [[UIImageView alloc] initWithImage:[UIImage imageNamed:CL_IMAGE_ICON_CHECKMARK]];
  }
  return self;
}

- (void)setIngredient:(CLIngredient *)ingredient {
  
  _ingredient = ingredient;
  self.ingredientLabel.text = _ingredient.name;
  
  CLDragView *dragView;
  
  for (UIView *view in self.subviews) {
    if ([view isKindOfClass:NSClassFromString(@"CLDragView")]) {
      dragView = (CLDragView*)view;
      break;
    }
  }
  /**
   There are 4 cases when reusing Tableview Cell:
   1) Drag view is in cell and we don't need it
   2) Drag view is in cell and we need it
   3) Drag view isn't in cell and we also don't need it
   4) Drag view isn't in cell but we need it
   Here we check which case we have and do the right action
   
   It begins with drag view is not in cell...
   */
  if (dragView == nil) {
    /**
     We don't need it, so we are happy and just set the label alpha
     */
    if ([[_ingredient selected] boolValue]) {
      self.ingredientLabel.alpha = 0.4;

      self.accessoryView = _checkmark;
    }
    /**
     We need it, so we allocate it...
     */
    else {
      
      self.ingredientLabel.alpha = 1.0;
      self.accessoryView = nil;

      dragView = [[CLDragView alloc] initWithFrame:self.bounds];
      dragView.delegate = self.rootController;
      dragView.label.text = _ingredient.name;
      dragView.ingredient = _ingredient;
      [self addSubview:dragView];
    }
  }
  else {
    /**
     We don't need it, so we remove it and set it to nil
     */
    if ([[_ingredient selected] boolValue]) {
      
      self.ingredientLabel.alpha = 0.4;
      self.accessoryView = _checkmark;
      [dragView removeFromSuperview];
      dragView = nil;
    }
    /**
     We need it, so we just set the right text and ingredient
     */
    else {
      
      self.ingredientLabel.alpha = 1.0;
      self.accessoryView = nil;
      dragView.label.text = _ingredient.name;
      dragView.ingredient = _ingredient;
    }
  }
}



@end
