//
//  CLIngredientCell.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLIngredientCell.h"

@interface CLIngredientCell (Private)

- (void)longPressDetected:(id)sender;

@end

@implementation CLIngredientCell

@synthesize ingredientLabel = _ingredientLabel;
@synthesize ingredient = _ingredient;
@synthesize delegate = _delegate;
@synthesize dragView = _dragView;

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

  [_dragView removeFromSuperview];
  _dragView = nil;
  
  _ingredient = ingredient;
  self.ingredientLabel.text = _ingredient.name;
  
  if ([[_ingredient selected] boolValue]) {
    self.ingredientLabel.alpha = 0.4;
    self.accessoryType = UITableViewCellAccessoryCheckmark;
  }
  else {
    _dragView = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, 44)];
    _dragView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_dragView];
    
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                  action:@selector(longPressDetected:)];
    [_dragView addGestureRecognizer:longPress];
    
    self.ingredientLabel.alpha = 1.0;
    self.accessoryType = UITableViewCellAccessoryNone;
  }  
}

- (void)longPressDetected:(UILongPressGestureRecognizer*)sender {

  if ([self.delegate respondsToSelector:@selector(detectedLongPressWithRecognizer:)]) {
    [self.delegate performSelector:@selector(detectedLongPressWithRecognizer:) 
                        withObject:sender];
  }
}

@end
