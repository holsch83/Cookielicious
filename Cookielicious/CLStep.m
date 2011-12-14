//
//  CLStep.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLStep.h"
#import "CLStepIngredient.h"

@implementation CLStep

@synthesize identifier = _identifier;
@synthesize duration = _duration;
@synthesize title = _title;
@synthesize description = _description;
@synthesize image = _image;
@synthesize ingredients = _ingredients;
@synthesize todos = _todos;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal {
  self = [super init];
  if(self) {
    [self setIdentifier:[[dictionaryVal objectForKey:@"id"] intValue]];
    [self setDuration:[[dictionaryVal objectForKey:@"duration"] intValue]];
    [self setTitle:[dictionaryVal objectForKey:@"title"]];
    [self setDescription:[dictionaryVal objectForKey:@"description"]];
    
    // Load the image
    NSURL *currImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/images/%@",CL_API_URL,[dictionaryVal objectForKey:@"image"]]];
    [self setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:currImageUrl]]]; 
    
    NSMutableArray *todos = [[NSMutableArray alloc] init];
    for(NSDictionary *todoDict in [dictionaryVal objectForKey:@"todos"]) {
      [todos addObject:[[CLTodo alloc] initWithDictionary:todoDict]];
    }
    [self setTodos:todos];
    
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    for(NSDictionary *ingredientDict in [dictionaryVal objectForKey:@"ingredients"]) {
      [ingredients addObject:[[CLStepIngredient alloc] initWithDictionary:ingredientDict]];
    }
    [self setIngredients:ingredients];
  }
  return self;
}

@end
