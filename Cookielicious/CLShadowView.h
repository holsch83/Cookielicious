//
//  CLFlipView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLRecipeDetailViewDelegate.h"

@interface CLShadowView : UIView <UIGestureRecognizerDelegate> {
  UIGestureRecognizer *_tapGestureRecognizer;
}

@property(nonatomic, assign) id <CLRecipeDetailViewDelegate> delegate;

@end
