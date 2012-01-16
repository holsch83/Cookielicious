//
//  UIAsyncImageView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 15.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLAsyncImageView.h"
#import "NSOperationQueue+SharedQueue.h"

@implementation CLAsyncImageView

- (void)setImageWithUrlString:(NSString *)imageUrl {
  [self setImage:nil];
  
  // Remove any activity indicator
  for(UIView *subview in [self subviews]) {
    [subview removeFromSuperview];
  }
  
  NSURL *url = [[NSURL alloc] initWithString:imageUrl];
  
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  __unsafe_unretained __block ASIHTTPRequest *blockRequest = request;
  
  [request setCompletionBlock:^{
    UIImage *theImage = [[UIImage alloc] initWithData:[blockRequest responseData]];
    [self setContentMode:UIViewContentModeScaleAspectFill];
    [self setImage:theImage];
  }];
  [request setFailedBlock:^{
    NSLog(@"CLAsyncImageView request failed");
  }];

  [[NSOperationQueue sharedOperationQueue] addOperation:request];
  
  [self setContentMode:UIViewContentModeCenter];
  [self setImage:[UIImage imageNamed:@"image_default.png"]];
}

@end
