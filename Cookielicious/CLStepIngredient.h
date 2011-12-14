//
//  CLStepIngredient.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLStepIngredient : NSObject

@property(nonatomic) int identifier;
@property(nonatomic) float amount;
@property(nonatomic, strong) NSString *unit;
@property(nonatomic, strong) NSString *name;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal;

@end
