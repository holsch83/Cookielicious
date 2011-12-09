//
//  CLResultRecipesController.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLResultRecipesController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *recipeGridView;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;

@end
