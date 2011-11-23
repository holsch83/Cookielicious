//
//  CLMainViewController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 09.11.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLMainViewController.h"
#import "CLIngredientCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CLMainViewController

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize ingredientCell = _ingredientCell;

@synthesize ingredients = _ingredients;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {

  self = [super initWithCoder:aDecoder];
  if (self) {
    self.ingredients = [[NSMutableArray alloc] initWithObjects:@"Alkohol", 
                        @"Bier", @"Cornflakes", @"Dill", @"Erbsen", @"Fleisch",
                        @"Zitronengras", @"Bambussprossen", nil];
  }
  return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 748)];
  view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern_wood.png"]];
  [self.view insertSubview:view 
              belowSubview:self.searchBar];
  
  view.layer.shadowColor = [[UIColor blackColor] CGColor];
  view.layer.shadowOffset = CGSizeMake(2.0, 0.0);
  view.layer.shadowRadius = 5.0;
  view.layer.shadowOpacity = 0.5;
  view.layer.masksToBounds = NO;
  view.layer.shouldRasterize = YES;
  
  
  
}

- (void)viewDidUnload {
  
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	return (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? YES : NO;
}



#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [self.ingredients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"IngredientCell";
  
  CLIngredientCell *cell = 
  (CLIngredientCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    
    [[NSBundle mainBundle] loadNibNamed:@"CLIngredientCell" 
                                  owner:self 
                                options:nil];
    cell = self.ingredientCell;
    
  }
  
  // Configure the cell.
  cell.ingredientLabel.text = [self.ingredients objectAtIndex:indexPath.row];
  return cell;
}


@end
