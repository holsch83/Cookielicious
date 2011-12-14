//
//  CLTodo.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 12.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLTodo : NSObject

@property(nonatomic) int identifier;
@property(nonatomic, strong) NSString *description;

- (id) initWithDictionary:(NSDictionary *)dictionaryVal;

@end
