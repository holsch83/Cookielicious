//
//  CLIngredientCell.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLIngredientCell.h"

@implementation CLIngredientCell

@synthesize ingredientLabel = _ingredientLabel;

- (NSString*)reuseIdentifier {
  return @"IngredientCell";
}

@end
