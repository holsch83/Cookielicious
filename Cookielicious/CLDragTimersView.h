//
//  CLDragTimersView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDragTimersView : UIView {
  BOOL isShowing;
  
  // The x offset for the timer subviews
  float _currOffset;
  
  UITapGestureRecognizer *_tapGestureRecognizer;
  
  CGPoint _touchStartPoint;
  CGRect _touchStartFrame;
  CGRect _originFrame;
}

@end
