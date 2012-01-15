//
//  CLStep.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLIngredient.h"
#import "CLTodo.h"

@interface CLStep : NSObject

@property(nonatomic) int identifier;
@property(nonatomic) int duration;
@property(nonatomic, strong) NSString *title;
@property(nonatomic, strong) NSString *description;
@property(nonatomic, strong) NSString *image;
@property(nonatomic, strong) NSNumber *timeable;
@property(nonatomic, strong) NSString *timerName;
@property(nonatomic, strong) NSArray *ingredients;
@property(nonatomic, strong) NSArray *todos;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal;

@end
