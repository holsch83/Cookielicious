//
//  CLIngredient.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 01.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CLIngredient : NSManagedObject

@property (nonatomic, strong) NSNumber *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *selected;
@property (nonatomic, strong) NSNumber *searchCount;

@end
