//
//  CLTodo.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLTodo.h"

@implementation CLTodo

@synthesize identifier = _identifier;
@synthesize description = _description;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal {
  self = [super init];
  if(self) {
    [self setIdentifier:[[dictionaryVal objectForKey:@"id"] intValue]];
    [self setDescription:[dictionaryVal objectForKey:@"description"]];
  }
  return self;
}

@end
