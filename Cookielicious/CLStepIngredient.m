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
    [self setIdentifier:[[dictionaryVal objectForKey:@"id"] intValue]];
    [self setAmount:[[dictionaryVal objectForKey:@"amount"] floatValue]];
    [self setUnit:[dictionaryVal objectForKey:@"unit"]];
    [self setName:[dictionaryVal objectForKey:@"name"]];
  }
  return self;
}

@end
