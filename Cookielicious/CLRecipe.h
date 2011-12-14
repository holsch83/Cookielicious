//
//  CLRecipe.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLStep.h"

@interface CLRecipe : NSObject

@property(nonatomic) int identifier;
@property(nonatomic) int preparationTime;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSArray *steps;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal;

- (NSArray *) ingredients;
- (NSString *) ingredientsWithSeparator:(NSString *)separatorVal;

@end
