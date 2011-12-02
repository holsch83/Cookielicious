//
//  CLIngredientCell.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLIngredientCell.h"
#import "CLDragView.h"

@interface CLIngredientCell (Private)

- (void)longPressDetected:(id)sender;

@end

@implementation CLIngredientCell

@synthesize ingredientLabel = _ingredientLabel;
@synthesize ingredient = _ingredient;
@synthesize delegate = _delegate;

- (NSString*)reuseIdentifier {
  return @"IngredientCell";
}

- (id)initWithCoder:(NSCoder *)aDecoder {

  self = [super initWithCoder:aDecoder];
  if (self) {
    
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
      self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    /**
     We need it, so we allocate it...
     */
    else {
      
      self.ingredientLabel.alpha = 1.0;
      self.accessoryType = UITableViewCellAccessoryNone;
      
      dragView = [[CLDragView alloc] initWithFrame:self.bounds];
      dragView.backgroundColor = [UIColor clearColor];
      dragView.label.text = _ingredient.name;
      dragView.ingredient = _ingredient;
      [self addSubview:dragView];
      
      UILongPressGestureRecognizer *longPress =
      [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                    action:@selector(longPressDetected:)];
      [dragView addGestureRecognizer:longPress];
    
    }
  }
  else {
    /**
     We don't need it, so we remove it and set it to nil
     */
    if ([[_ingredient selected] boolValue]) {
      
      self.ingredientLabel.alpha = 0.4;
      self.accessoryType = UITableViewCellAccessoryCheckmark;
      [dragView removeFromSuperview];
      dragView = nil;
    }
    /**
     We need it, so we just set the right text and ingredient
     */
    else {
      
      self.ingredientLabel.alpha = 1.0;
      self.accessoryType = UITableViewCellAccessoryNone;
      dragView.label.text = _ingredient.name;
      dragView.ingredient = _ingredient;
    }
  }
}

- (void)longPressDetected:(UILongPressGestureRecognizer*)sender {

  if ([self.delegate respondsToSelector:@selector(detectedLongPressWithRecognizer:)]) {
    [self.delegate performSelector:@selector(detectedLongPressWithRecognizer:) 
                        withObject:sender];
  }
}

@end
