//
//  CLFavorite.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 16.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CLImageTransformer.h"


@interface CLFavorite : NSManagedObject

@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSNumber * identifier;
@property (nonatomic, strong) UIImage * previewImage;
@property (nonatomic, strong) NSDate * date;

- (NSString*)formattedDate;

@end
