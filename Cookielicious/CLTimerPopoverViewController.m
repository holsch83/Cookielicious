//
//  CLTimerPopoverViewController.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 11.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLTimerPopoverViewController.h"

@implementation CLTimerPopoverViewController

@synthesize delegate = _delegate;

#pragma mark - Actions

- (IBAction)touchedTimerDeleteButton:(id)sender {
  if([_delegate respondsToSelector:@selector(touchedTimerDeleteButton)]) {
    [_delegate performSelector:@selector(touchedTimerDeleteButton)];
  }
}

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Timer löschen" style:UIBarButtonItemStyleBordered target:self action:@selector(touchedTimerDeleteButton:)];
    [self.view addSubview:button];
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  
  
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
