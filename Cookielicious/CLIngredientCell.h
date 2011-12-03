//
//  CLIngredientCell.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLIngredient;
@class CLMainViewController;

@interface CLIngredientCell : UITableViewCell

@property (strong, nonatomic, readonly) IBOutlet UILabel *ingredientLabel;
@property (strong, nonatomic) CLIngredient *ingredient;
@property (assign, nonatomic) IBOutlet CLMainViewController *rootController;


@end
