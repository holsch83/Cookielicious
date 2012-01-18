//
//  CLFavorite.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 16.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLFavorite.h"


@implementation CLFavorite

@dynamic title;
@dynamic identifier;
@dynamic previewImage;
@dynamic date;

- (NSString*)formattedDate {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
  [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
  
  NSLocale *deLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"de_DE"];
  [dateFormatter setLocale:deLocale];
  
  return [dateFormatter stringFromDate:self.date];
}


@end
