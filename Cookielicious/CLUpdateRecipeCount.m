//
//  CLUpdateRecipeCount.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 06.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLUpdateRecipeCount.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@implementation CLUpdateRecipeCount

@synthesize delegate = _delegate;

- (void)requestFinished:(ASIHTTPRequest*) request {
  NSLog(@"Recipe count request finished");
  
  NSDictionary *response = (NSDictionary *)[[request responseString] objectFromJSONString];
  for (NSString *key in [response allKeys]) {
    if([key isEqualToString:@"count"]) {
      int count = [[response objectForKey:@"count"] intValue];
      
      if ([_delegate respondsToSelector:@selector(updateRecipeCount:)]) {
        [_delegate performSelector:@selector(updateRecipeCount:) withObject:[NSNumber numberWithInt:count]];
      }
    }
  }
}

- (void)requestFailed:(ASIHTTPRequest*) request {
  NSLog(@"Recipe count request failed");
}

@end
