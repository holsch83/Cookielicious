//
//  CLFavorite.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 16.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CLFavorite : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * identifier;

@end
