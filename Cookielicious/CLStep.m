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
@synthesize timeable = _timeable;
@synthesize timerName = _timerName;
@synthesize ingredients = _ingredients;
@synthesize todos = _todos;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal {
  self = [super init];
  if(self) {
    [self setIdentifier:[[dictionaryVal objectForKey:CL_API_JSON_IDKEY] intValue]];
    [self setDuration:[[dictionaryVal objectForKey:CL_API_JSON_DURATIONKEY] intValue]];
    [self setTitle:[dictionaryVal objectForKey:CL_API_JSON_TITLEKEY]];
    [self setDescription:[dictionaryVal objectForKey:CL_API_JSON_DESCRIPTIONKEY]];
    [self setTimeable:[NSNumber numberWithInt:[[dictionaryVal objectForKey:CL_API_JSON_TIMEABLEKEY] intValue]]];
    [self setTimerName:[dictionaryVal objectForKey:CL_API_JSON_TIMERNAMEKEY]];
    
    // Load the image
    NSURL *currImageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",CL_API_ASSETSURL,[dictionaryVal objectForKey:CL_API_JSON_IMAGEKEY]]];
    [self setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:currImageUrl]]]; 
    
    NSMutableArray *todos = [[NSMutableArray alloc] init];
    for(NSDictionary *todoDict in [dictionaryVal objectForKey:CL_API_JSON_TODOSKEY]) {
      [todos addObject:[[CLTodo alloc] initWithDictionary:todoDict]];
    }
    [self setTodos:todos];
    
    NSMutableArray *ingredients = [[NSMutableArray alloc] init];
    for(NSDictionary *ingredientDict in [dictionaryVal objectForKey:CL_API_JSON_INGREDIENTSKEY]) {
      [ingredients addObject:[[CLStepIngredient alloc] initWithDictionary:ingredientDict]];
    }
    [self setIngredients:ingredients];
  }
  return self;
}

@end
