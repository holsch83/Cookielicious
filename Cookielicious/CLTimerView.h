//
//  CLTimerView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLTimerView : UIView {
  UITapGestureRecognizer *_tapGestureRecognizer;
}

- (void) touchedView;

@end
