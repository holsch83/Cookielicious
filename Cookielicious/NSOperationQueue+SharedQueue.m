//
//  NSOperationQueue+SharedQueue.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 16.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "NSOperationQueue+SharedQueue.h"

@implementation NSOperationQueue (SharedQueue)
+ (NSOperationQueue*)sharedOperationQueue;
{
  static NSOperationQueue* sharedQueue = nil;
  if (sharedQueue == nil) {
    sharedQueue = [[NSOperationQueue alloc] init];
  }
  return sharedQueue;
}
@end