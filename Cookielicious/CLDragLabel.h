//
//  CLDragLabel.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 25.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLIngredientCell;

@interface CLDragLabel : UILabel

@property (assign, nonatomic) CLIngredientCell *parentCell;

@end
