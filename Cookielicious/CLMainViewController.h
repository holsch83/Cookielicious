//
//  CLMainViewController.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 09.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "CLSearchBar.h"
#import "CLIngredientCell.h"
#import "CLDragViewDelegate.h"
#import "CLSelectedIngredientsController.h"

@class CLSelectedIngredientsController;

@interface CLMainViewController : UIViewController <UITableViewDelegate, 
UITableViewDataSource, NSFetchedResultsControllerDelegate, UISearchBarDelegate,
CLDragViewDelegate, ASIHTTPRequestDelegate> {

  @private
  CGPoint _startingDragPosition;
  bool _didSynchronizeIngredients;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet CLSearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *potView;
@property (strong, nonatomic) IBOutlet CLIngredientCell *ingredientCell;
@property (strong, nonatomic) IBOutlet UIButton *showRecipesButton;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;

@property (strong, nonatomic) CLSelectedIngredientsController *selectedIngredientsController;

@end
