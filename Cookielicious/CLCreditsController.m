//
//  CLCreditsController.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 12.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLCreditsController.h"

@implementation CLCreditsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
      // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark Touch event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

  [self dismissModalViewControllerAnimated:YES];
}

@end
