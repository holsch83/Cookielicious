//
//  CLDragView.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 01.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLIngredient;

@interface CLDragView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CLIngredient *ingredient;

@end
