//
//  CLRecipe.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLRecipe.h"
#import "SBJson.h"

@implementation CLRecipe

@synthesize identifier = _identifier;
@synthesize preparationTime = _preparationTime;
@synthesize title = _title;
@synthesize image = _image;
@synthesize steps = _steps;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal {
  self = [super init];
  if(self) {
    [self setIdentifier:[[dictionaryVal objectForKey:@"id"] intValue]];
    [self setPreparationTime:[[dictionaryVal objectForKey:@"preparation_time"] intValue]];
    [self setTitle:[dictionaryVal objectForKey:@"title"]];
    
    // Load the image
    NSURL *currImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/assets/%@",CL_API_URL,[dictionaryVal objectForKey:@"image"]]];
    [self setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:currImageUrl]]];
    NSLog(@"Fetching image at: %@/assets/%@",CL_API_URL,[dictionaryVal objectForKey:@"image"]);
    // Set up steps
    NSMutableArray *steps = [[NSMutableArray alloc] init];
    for(NSDictionary *stepDict in [[dictionaryVal objectForKey:@"steps"] allValues]) {
      //NSLog(@"%d", [stepDict isKindOfClass:NSClassFromString(@"NSDictionary")]);
      //NSLog(@"%@", (NSString*)stepDict);
      [steps addObject:[[CLStep alloc] initWithDictionary:stepDict]];
    }
    [self setSteps:steps];
  }
  return self;
}

#pragma mark - Accessor methods

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
