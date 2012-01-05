//
//  CLStepView.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLStep;

@interface CLStepView : UIView {

  IBOutlet UILabel *_titleLabel;
  IBOutlet UILabel *_descriptionLabel;
}

- (void)configureViewWithStep:(CLStep*)step;

@end
