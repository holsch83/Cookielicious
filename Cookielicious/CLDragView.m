//
//  CLDragView.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 01.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLDragView.h"
#import "CLIngredient.h"

@implementation CLDragView

@synthesize label = _label;
@synthesize ingredient = _ingredient;

- (id)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  if (self) {
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 44)];
    _label.backgroundColor = [UIColor clearColor];
    _label.textColor = [UIColor clearColor];
    _label.font = [UIFont fontWithName:@"Noteworthy bold" size:18.0];
    [self addSubview:_label];
  }
  return self;
}

@end
