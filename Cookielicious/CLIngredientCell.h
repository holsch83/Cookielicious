//
//  CLIngredientCell.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLIngredient.h"

@protocol CLIngredientCellLongPressDelegate <NSObject>

- (void)detectedLongPressWithRecognizer:(UILongPressGestureRecognizer*)recognizer;

@end

@interface CLIngredientCell : UITableViewCell

@property (strong, nonatomic) id <NSObject> delegate;
@property (strong, nonatomic, readonly) IBOutlet UILabel *ingredientLabel;
@property (strong, nonatomic) CLIngredient *ingredient;
@property (strong, nonatomic) UIView *dragView;


@end
