//
//  CLIngredientCell.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLIngredientCell.h"
#import "CLDragLabel.h"

@implementation CLIngredientCell

@synthesize dragLabel = _dragLabel;
@synthesize ingredientLabel = _ingredientLabel;

- (NSString*)reuseIdentifier {
  return @"IngredientCell";
}

- (id)initWithCoder:(NSCoder *)aDecoder {

  self = [super initWithCoder:aDecoder];
  if (self) {
    _dragLabel = [[CLDragLabel alloc] initWithFrame:self.bounds];
    _dragLabel.backgroundColor = [UIColor clearColor];
    _dragLabel.textColor = [UIColor clearColor];
    _dragLabel.textAlignment = UITextAlignmentCenter;
    _dragLabel.parentCell = self;
    [self addSubview:_dragLabel];
  }
  return self;
}

@end
