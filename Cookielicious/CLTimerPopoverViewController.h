//
//  CLTimerPopoverViewController.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 11.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTimerPopoverViewControllerDelegate.h"

@interface CLTimerPopoverViewController : UIViewController {
  IBOutlet UIButton *_deleteTimerButton;
}

@property(nonatomic, assign) id<CLTimerPopoverViewControllerDelegate> delegate;

- (IBAction) touchedTimerDeleteButton:(id)sender;

@end
