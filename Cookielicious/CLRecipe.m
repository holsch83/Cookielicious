//
//  CLRecipe.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLRecipe.h"
#import "CLStepIngredient.h"

@implementation CLRecipe

@synthesize identifier = _identifier;
@synthesize preparationTime = _preparationTime;
@synthesize title = _title;
@synthesize image = _image;
@synthesize steps = _steps;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal {
  self = [super init];
  if(self) {
    [self setIdentifier:[[dictionaryVal objectForKey:CL_API_JSON_IDKEY] intValue]];
    [self setPreparationTime:[[dictionaryVal objectForKey:CL_API_JSON_PREPARATIONTIMEKEY] intValue]];
    [self setTitle:[dictionaryVal objectForKey:CL_API_JSON_TITLEKEY]];
    [self setImage:[NSString stringWithFormat:@"%@/%@",CL_API_ASSETSURL,[dictionaryVal objectForKey:CL_API_JSON_IMAGEKEY]]];

    // Set up steps
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    for(NSDictionary *stepDict in [[dictionaryVal objectForKey:CL_API_JSON_STEPSKEY] allValues]) {
      [steps addObject:[[CLStep alloc] initWithDictionary:stepDict]];
    }
    [self setSteps:steps];
  }
  return self;
}

#pragma mark - Accessor methods

- (bool) containsIngredient:(CLIngredient *)ingredientVal {
  for (CLStepIngredient *currIngredient in [self ingredients]) {
    if([currIngredient.name isEqualToString:ingredientVal.name]) {
      return YES;
    }
  }
  
  return NO;
}

- (bool) containsIngredients:(NSArray *)ingredientsVal {
  for(CLIngredient *currIngredient in ingredientsVal) {
    bool contains = NO;
    for(CLStepIngredient *currStepIngredient in [self ingredients]) {
      if([currStepIngredient.name isEqualToString:currIngredient.name]) {
        contains = YES;
        break;
      }
    }
    
    if(! contains) {
      return NO;
    }
  }
  
  return YES;
}

- (NSArray *) ingredients {
  NSMutableArray *ingredients = [[NSMutableArray alloc] init];
  for(CLStep *step in [self steps]) {
    [ingredients addObjectsFromArray:[step ingredients]];
  }
  return ingredients;
}

- (NSString *) ingredientsWithSeparator:(NSString *)separatorVal {
  NSArray *ingredients = [self ingredients];
  NSMutableString *ingredientString = [[NSMutableString alloc] init];
  for(int i = 0, j = [ingredients count]; i < j; i++) {
    CLIngredient *ingredient = [ingredients objectAtIndex:i];
    
    if(i == j-1) {
      // Last item
      [ingredientString appendString:[ingredient name]];
    }
    else {
      [ingredientString appendFormat:@"%@%@", [ingredient name], separatorVal];
    }
  }
  return ingredientString;
}

@end
