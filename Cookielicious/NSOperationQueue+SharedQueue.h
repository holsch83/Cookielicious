//
//  NSOperationQueue+SharedQueue.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 16.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

@interface NSOperationQueue (SharedQueue)

+ (NSOperationQueue*)sharedOperationQueue;

@end
