//
//  CLTimersView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLTimerView.h"

@interface CLTimersView : UIView {
  float _currOffset;
}

- (void)reorderSubviews;

@end