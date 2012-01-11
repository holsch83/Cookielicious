//
//  CLTimersView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTimerViewDelegate.h"

@interface CLTimersView : UIView<CLTimerViewDelegate> {
  float _currOffset;
  
  UIPopoverController *_popoverController;
}

@end
