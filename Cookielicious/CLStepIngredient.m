//
//  CLStepIngredient.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLStepIngredient.h"

@implementation CLStepIngredient

@synthesize identifier = _identifier;
@synthesize amount = _amount;
@synthesize unit = _unit;
@synthesize name = _name;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal {
  self = [super init];
  if(self) {
    [self setIdentifier:[[dictionaryVal objectForKey:CL_API_JSON_IDKEY] intValue]];
    [self setAmount:[[dictionaryVal objectForKey:CL_API_JSON_AMOUNTKEY] floatValue]];
    [self setUnit:[dictionaryVal objectForKey:CL_API_JSON_UNITKEY]];
    [self setName:[dictionaryVal objectForKey:CL_API_JSON_NAMEKEY]];
  }
  return self;
}

@end
