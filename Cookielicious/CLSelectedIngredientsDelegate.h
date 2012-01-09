//
//  CLSelectedIngredientsDelegate.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 09.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLSelectedIngredientsController;

@protocol CLSelectedIngredientsDelegate <NSObject>

- (void)selectedIngredientsController:(CLSelectedIngredientsController*)controller didRemoveAllIngredients:(NSMutableArray*)ingredients;

@end
