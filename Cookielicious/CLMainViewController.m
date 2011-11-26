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

@interface CLMainViewController (Private)

- (void)longPressDetectedByRecognizer:(UILongPressGestureRecognizer*)recognizer;

@end

@implementation CLMainViewController

@synthesize tableView = _tableView;
@synthesize searchBar = _searchBar;
@synthesize potView = _potView;
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
    
    UILongPressGestureRecognizer *longPress = 
    [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                  action:@selector(longPressDetectedByRecognizer:)];
    [cell.dragLabel addGestureRecognizer:longPress];
    
  }
  
  // Configure the cell.
  
  cell.ingredientLabel.text = [self.ingredients objectAtIndex:indexPath.row];
  cell.dragLabel.text = cell.ingredientLabel.text;
  [cell.dragLabel setUserInteractionEnabled:YES];
  return cell;
}

- (void)longPressDetectedByRecognizer:(UILongPressGestureRecognizer*)recognizer {

  NSLog(@"longPressDetectedByRecognizer::");
  
  CLDragLabel *dragableLabel = (CLDragLabel*)[recognizer view];
  CGPoint longPressPoint = [recognizer locationOfTouch:0 inView:self.view];
  CGRect labelFrame = dragableLabel.frame;
  
  switch ([recognizer state]) {
      
    case UIGestureRecognizerStateBegan:
      NSLog(@"UIGestureRecognizerStateBegan::");
      
      dragableLabel.textColor = [UIColor blueColor];
      dragableLabel.backgroundColor = [UIColor whiteColor];
      
      labelFrame.origin.x = longPressPoint.x - 30;
      labelFrame.origin.y = longPressPoint.y - 10;
      
      dragableLabel.frame = labelFrame;
      [self.view addSubview:dragableLabel];
      break;
      
    case UIGestureRecognizerStateChanged:
      NSLog(@"UIGestureRecognizerStateChanged::");
      
      labelFrame.origin.x = longPressPoint.x - 30;
      labelFrame.origin.y = longPressPoint.y - 10;
      dragableLabel.frame = labelFrame;
      
      break;
      
    case UIGestureRecognizerStateEnded:
      NSLog(@"UIGestureRecognizerStateEnded::");
      
      if ((longPressPoint.x > self.potView.frame.origin.x) &&
          (longPressPoint.y > self.potView.frame.origin.y)) {
        [self.potView addSubview:dragableLabel];
        labelFrame.origin.x = 0;
        labelFrame.origin.y = 0;
        dragableLabel.frame = labelFrame;
      }
      else {
      
        CLIngredientCell *parent = dragableLabel.parentCell;
        [parent addSubview:dragableLabel];
        labelFrame.origin.x = 0;
        labelFrame.origin.y = 0;
        dragableLabel.frame = labelFrame;
        dragableLabel.textColor = [UIColor clearColor];
        dragableLabel.backgroundColor = [UIColor clearColor];
        
      }
      
      break;
      
    case UIGestureRecognizerStateCancelled:
      NSLog(@"UIGestureRecognizerStateCancelled::");
      break;
      
    case UIGestureRecognizerStateFailed:
      NSLog(@"UIGestureRecognizerStateFailed::");
      break;
      
    default:
      break;
  }
}


@end
