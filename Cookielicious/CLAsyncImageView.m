//
//  UIAsyncImageView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 15.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLAsyncImageView.h"

@implementation CLAsyncImageView

- (void)setImage:(NSString *)imageUrl {
  [super setImage:nil];
  
  NSURL *url = [[NSURL alloc] initWithString:imageUrl];
  
  ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
  
  [request setDelegate:self];
  [request startAsynchronous];
}

#pragma mark - ASIHTTPRequestDelegate

- (void) requestStarted:(ASIHTTPRequest *)request {
  NSLog(@"Requesting image started");
  
  _activityIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
  [_activityIndicatorView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
  
  UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  [indicator startAnimating];
    
  indicator.frame = CGRectMake((self.frame.size.width / 2) - (indicator.frame.size.width / 2), (self.frame.size.height / 2) - (indicator.frame.size.height / 2), indicator.frame.size.width, indicator.frame.size.height);
  
  [_activityIndicatorView addSubview:indicator];
  [self addSubview:_activityIndicatorView];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
  NSLog(@"Request finished");
  
  UIImage *theImage = [[UIImage alloc] initWithData:[request responseData]];
  [super setImage:theImage];
  
  [_activityIndicatorView removeFromSuperview];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
  NSLog(@"Request failed");
}

@end
