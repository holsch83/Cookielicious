//
//  CLDragView.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 01.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLDragView.h"
#import "CLIngredient.h"

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
@synthesize ingredientsController = _ingredientsController;

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

@end
