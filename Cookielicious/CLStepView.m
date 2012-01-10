//
//  CLStepView.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLStepView.h"
#import "CLStep.h"

@implementation CLStepView

- (void)configureViewWithStep:(CLStep *)step {

  _titleLabel.text = [NSString stringWithFormat:@"%@", step.title];
  _descriptionLabel.text = [NSString stringWithFormat:@"%@", step.description];

  // TODO: Show or hide button
  
}

@end
