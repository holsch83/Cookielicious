//
//  CLDragView.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 01.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

typedef enum {
  CLShadowRed,
  CLShadowGreen,
  CLShadowDefault
} CLShadow;

#import <UIKit/UIKit.h>
#import "CLLabel.h"

@class CLIngredient;

@interface CLDragView : UIView {

  @private
  BOOL _isDragging;
  UIButton *_removeButton;
}

@property (nonatomic, strong) id <NSObject> delegate;
@property (nonatomic, strong) CLLabel *label;
@property (nonatomic, strong) CLIngredient *ingredient;

- (void)setVisible:(BOOL)visible;
- (void)startDraggingAnimation;
- (void)stopDraggingAnimation;
- (void)setShadow:(CLShadow)shadow;

@end
