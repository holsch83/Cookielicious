//
//  UIAsyncImageView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 15.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface CLAsyncImageView : UIImageView <ASIHTTPRequestDelegate> {
  UIView *_activityIndicatorView;
}

- (void)setImageWithUrlString:(NSString *)imageUrl;

@end
