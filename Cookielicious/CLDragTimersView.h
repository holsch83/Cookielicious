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
  
  CGPoint touchStartPoint;
  CGRect touchStartFrame;
}

@end
