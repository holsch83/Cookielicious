//
//  CLDragView.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 01.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLDragView.h"
#import "CLIngredient.h"
#import <QuartzCore/QuartzCore.h>

@interface CLDragView (Private)

- (IBAction)touchedRemoveButton:(UIButton*)sender;
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
@synthesize removeButton = _removeButton;
@synthesize imageView = _imageView;
@synthesize ingredient = _ingredient;
@synthesize delegate = _delegate;

- (id)initWithCoder:(NSCoder *)aDecoder {
  
  self = [super initWithCoder:aDecoder];
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

  }
  return self;
}

- (IBAction)touchedRemoveButton:(UIButton*)sender {
  
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
    [UIView animateWithDuration:0.4 animations:^{
      
      self.removeButton.alpha = 1.0;
      self.label.alpha = 1.0;
      self.imageView.alpha = 1.0;
      
      self.label.layer.shadowColor = [[UIColor blackColor] CGColor];
      self.label.layer.shadowOffset = CGSizeMake(2.0, 0.0);
      self.label.layer.shadowRadius = 5.0;
      self.label.layer.shadowOpacity = 0.5;
      self.label.layer.masksToBounds = NO;
      self.label.layer.shouldRasterize = YES;
      
    } completion:^(BOOL finished){
    }];
  }
  else {
    [UIView animateWithDuration:0.4 animations:^{
      
      self.removeButton.alpha = 0.0;
      self.label.alpha = 0.0;
      self.imageView.alpha = 0.0;
      
      self.label.layer.shadowColor = nil;
      self.label.layer.shadowOffset = CGSizeMake(0.0, 0.0);
      self.label.layer.shadowRadius = 0.0;
      self.label.layer.shadowOpacity = 0.0;
      
    } completion:^(BOOL finished){
      
      [self removeFromSuperview];
      
    }];
  
  }
}

- (void)setShadow:(CLShadow)shadow {

  [UIView animateWithDuration:0.4 animations:^{
    switch (shadow) {
      case CLShadowGreen:
        self.label.layer.shadowColor = [[UIColor greenColor] CGColor];
        self.label.layer.shadowOpacity = 1.0;
        break;
      case CLShadowRed:
        self.label.layer.shadowColor = [[UIColor redColor] CGColor];
        self.label.layer.shadowOpacity = 1.0;
        break;
      case CLShadowDefault:
        self.label.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.label.layer.shadowOpacity = 0.5;
        break;
      default:
        break;
    }
  } completion:^(BOOL finished){}];
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
    
    self.label.layer.shadowRadius = 10.0;
    self.label.layer.shadowOpacity = 0.4;
    
  } completion:^(BOOL finished) {
    [self animateRotationRight];
  }];
}

- (void)scaleDown {
  
  [UIView animateWithDuration:0.4 animations:^{
    CGAffineTransform zoom = 
    CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0); 
    self.transform = zoom;
    
    self.label.layer.shadowRadius = 5.0;
    self.label.layer.shadowOpacity = 0.5;
    
  }];
}

@end
