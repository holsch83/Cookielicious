//
//  CLDragView.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 01.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLDragView.h"
#import "CLIngredient.h"

#define DRAG_VIEW_PADDING 10

@interface CLDragView (Private)

// Creating subviews
- (void)createLabel;
- (void)createButton;

// Drag view actions
- (void)touchedRemoveButton:(UIButton*)sender;
- (void)longPressDetected:(UILongPressGestureRecognizer*)sender;
- (void)tapDetected:(UITapGestureRecognizer*)sender;

// Custom animations for floating effect and scaling when dragging view
- (void)animateRotationRight;
- (void)animateRotationLeft;
- (void)scaleUp;
- (void)scaleDown;

@end

@implementation CLDragView

@synthesize label = _label;
@synthesize ingredient = _ingredient;
@synthesize delegate = _delegate;

#pragma mark - Init and creation

- (id)initWithFrame:(CGRect)frame {

  self = [super initWithFrame:frame];
  if (self) {
    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self 
                                                  action:@selector(longPressDetected:)];
    longPress.minimumPressDuration = 0.2;
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self 
                                            action:@selector(tapDetected:)];
    [self addGestureRecognizer:longPress];
    [self addGestureRecognizer:tap];
    
    [self createLabel];
    [self createButton];
    
    _removeButton.alpha = 0.0;
    self.label.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)createLabel {

  _label = [[CLLabel alloc] initWithFrame:self.bounds];
  _label.textColor = [UIColor whiteColor];
  _label.glowColor = [UIColor blackColor];
  _label.backgroundColor = [UIColor clearColor];
  _label.font = [UIFont fontWithName:@"Noteworthy-Bold" size:18.0];
  _label.textAlignment = UITextAlignmentCenter;
  
  [self addSubview:_label];
}

- (void)createButton {
  _removeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-24, 10, 
                                                             24, 24)];
  [_removeButton setImage:[UIImage imageNamed:CL_IMAGE_ICON_DELETE] 
                 forState:UIControlStateNormal];
  [_removeButton addTarget:self 
                    action:@selector(touchedRemoveButton:) 
          forControlEvents:UIControlEventTouchUpInside];
  _removeButton.backgroundColor = [UIColor clearColor];
  
  
  [self addSubview:_removeButton];
  
}


#pragma mark - Layout

- (void)layoutSubviews {

  CGRect labelRect = CGRectMake(DRAG_VIEW_PADDING,
                                DRAG_VIEW_PADDING/2, 
                                self.bounds.size.width - 2*DRAG_VIEW_PADDING - _removeButton.frame.size.width, 
                                self.bounds.size.height - DRAG_VIEW_PADDING);
  _label.frame = labelRect;
  
  CGRect buttonRect = CGRectMake(self.bounds.size.width - _removeButton.frame.size.width - DRAG_VIEW_PADDING,
                                 (self.bounds.size.height - _removeButton.frame.size.height)/2, 
                                 _removeButton.frame.size.width, 
                                 _removeButton.frame.size.height);
  _removeButton.frame = buttonRect;
  
}

#pragma mark - Drag view interaction

- (void)touchedRemoveButton:(UIButton*)sender {
  
  if ([self.delegate respondsToSelector:@selector(removeDragView:withIngredient:)]) {
    
    [self.delegate performSelector:@selector(removeDragView:withIngredient:) 
                        withObject:self
                        withObject:self.ingredient];
  }
}

- (void)longPressDetected:(UILongPressGestureRecognizer*)sender {
  
  if ([self.delegate respondsToSelector:@selector(dragView:detectedLongPressWithRecognizer:)]) {
    [self.delegate performSelector:@selector(dragView:detectedLongPressWithRecognizer:) 
                        withObject:self
                        withObject:sender];
  }
}

- (void)tapDetected:(UITapGestureRecognizer*)sender {
  
  if ([self.delegate respondsToSelector:@selector(dragView:detectedTapWithRecognizer:)]) {
    [self.delegate performSelector:@selector(dragView:detectedTapWithRecognizer:) 
                        withObject:self
                        withObject:sender];
  }
}

- (void)setVisible:(BOOL)visible {

  if (visible) {
    
    CGPoint center = self.center;
    CGRect newRect = self.frame;
    newRect.size.width = newRect.size.width/2;
    self.frame = newRect;
    self.center = center;
    
    [UIView animateWithDuration:0.4 animations:^{
      
      _removeButton.alpha = 1.0;
      self.label.alpha = 1.0;
      
    } completion:^(BOOL finished){
    }];
  }
  else {
    [UIView animateWithDuration:0.4 animations:^{
      
      _removeButton.alpha = 0.0;
      self.label.alpha = 0.0;

      
    } completion:^(BOOL finished){
      
      [self removeFromSuperview];
      
    }];
  
  }
}

- (void)setShadow:(CLShadow)shadow {

  switch (shadow) {
    case CLShadowGreen:
      _label.glowColor = [UIColor greenColor];
      break;
    case CLShadowRed:
      _label.glowColor = [UIColor redColor];
      break;
    case CLShadowDefault:
      _label.glowColor = [UIColor blackColor];
      break;
    default:
      break;
  }
}

- (void)startDraggingAnimation {

  _isDragging = YES;
  [self scaleUp];
}

- (void)stopDraggingAnimation {
  
  _isDragging = NO;
  [self scaleDown];
  [self setShadow:CLShadowDefault];
}
- (void)animateRotationRight {
  if (_isDragging) {
    
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                       CGAffineTransform rotateRight = 
                       CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2), M_PI_4/10); 
                       self.transform = rotateRight;
                     } 
                     completion:^(BOOL finished) {
                       [self animateRotationLeft];
                     }];
   
  }
}
- (void)animateRotationLeft {
  if (_isDragging) {
    
    [UIView animateWithDuration:0.5 
                          delay:0.0 
                        options:UIViewAnimationOptionAllowUserInteraction 
                     animations:^{
                       CGAffineTransform rotateLeft = 
                       CGAffineTransformRotate(CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2), -M_PI_4/10); 
                       self.transform = rotateLeft;
                     } 
                     completion:^(BOOL finished) {
                       [self animateRotationRight];
                     }]; 
  }
}

- (void)scaleUp {
    
  [UIView animateWithDuration:0.4 animations:^{
    CGAffineTransform zoom = 
    CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2); 
    self.transform = zoom;
    
  } completion:^(BOOL finished) {
    [self animateRotationRight];
  }];
}

- (void)scaleDown {
  
  [UIView animateWithDuration:0.4 animations:^{
    CGAffineTransform zoom = 
    CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0); 
    self.transform = zoom;
  
    
  }];
}

@end
