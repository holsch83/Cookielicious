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
    [self addGestureRecognizer:longPress];
    

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
  
  if ([self.delegate respondsToSelector:@selector(detectedLongPressWithRecognizer:)]) {
    [self.delegate performSelector:@selector(detectedLongPressWithRecognizer:) 
                        withObject:sender];
  }
}

- (void)setVisible {

  self.removeButton.alpha = 1.0;
  self.label.alpha = 1.0;
  self.imageView.alpha = 1.0;
  
  self.label.layer.shadowColor = [[UIColor blackColor] CGColor];
  self.label.layer.shadowOffset = CGSizeMake(2.0, 0.0);
  self.label.layer.shadowRadius = 5.0;
  self.label.layer.shadowOpacity = 0.5;
  self.label.layer.masksToBounds = NO;
  self.label.layer.shouldRasterize = YES;
  
}

@end
