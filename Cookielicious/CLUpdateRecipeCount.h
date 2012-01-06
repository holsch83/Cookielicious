//
//  CLUpdateRecipeCount.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 06.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"

@protocol CLRecipeButtonDelegate <NSObject>

- (void) updateRecipeCount:(NSNumber *)count;

@end


@interface CLUpdateRecipeCount : NSObject <ASIHTTPRequestDelegate>

@property (nonatomic, assign) id<CLRecipeButtonDelegate> delegate;

@end
