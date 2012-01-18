//
//  CLImageTransformer.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 18.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLImageTransformer.h"

@implementation CLImageTransformer

+ (BOOL)allowsReverseTransformation { 
  
  return YES;
}

+ (Class)transformedValueClass { 
  
  return [NSData class];
}

- (id)transformedValue:(id)value {
  
  if (value == nil)
    return nil;
  
  // I pass in raw data when generating the image, save that directly to the database
  if ([value isKindOfClass:[NSData class]])
    return value;
  
  return UIImagePNGRepresentation((UIImage *)value);
}

- (id)reverseTransformedValue:(id)value {
  
  return [UIImage imageWithData:(NSData*)value];
} 

@end
