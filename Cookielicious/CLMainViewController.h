//
//  CLMainViewController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 09.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLSearchBar.h"
#import "CLIngredientCell.h"

@interface CLMainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet CLSearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *potView;
@property (strong, nonatomic) IBOutlet CLIngredientCell *ingredientCell;

@property (strong, nonatomic) NSMutableArray *ingredients;


@end
