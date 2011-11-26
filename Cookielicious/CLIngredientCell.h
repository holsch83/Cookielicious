//
//  CLIngredientCell.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 23.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLDragLabel.h"

@interface CLIngredientCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *ingredientLabel;
@property (strong, nonatomic) CLDragLabel *dragLabel;

@end
