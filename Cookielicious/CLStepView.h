//
//  CLStepView.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLStepViewDelegate.h"

@class CLStep;

@interface CLStepView : UIView {
  CLStep *_step;
  
  IBOutlet UIButton *_setTimerButton;

  IBOutlet UIImageView *_imageView;
  IBOutlet UILabel *_durationLabel;
  IBOutlet UILabel *_titleLabel;
  IBOutlet UITextView *_ingredientsText;
  IBOutlet UITextView *_descriptionText;
  IBOutlet UITextView *_todoText;
  
}

@property(nonatomic, assign) id<CLStepViewDelegate> delegate;

- (void)configureViewWithStep:(CLStep*)step;
- (void)enableTimer:(NSString *)timerName;
- (IBAction)touchedSetTimerButton:(id)sender;

@end
