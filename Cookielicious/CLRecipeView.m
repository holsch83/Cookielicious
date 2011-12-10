//
//  CLRecipeView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLRecipeView.h"

@interface CLRecipeView (Private)

- (void) makeShadow:(CALayer *)layer;

@end

@implementation CLRecipeView

@synthesize titleLabel = _titleLabel;
@synthesize delegate = _delegate;

#pragma mark - Object initialization

- (id) init {
    self = [super init];
    if(self) {
        //[self makeShadow:self.layer];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self) {
        //[self makeShadow:self.layer];
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //[self makeShadow:self.layer];
    }
    return self;
}

#pragma mark - Private member

- (void) makeShadow:(CALayer *)layer {
    layer.shadowColor = [UIColor blackColor].CGColor;
    layer.shadowOpacity = 0.2;
    layer.shadowRadius = 3;
    layer.shadowOffset = CGSizeMake(0, 0);
}

#pragma mark - User interaction

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([_delegate respondsToSelector:@selector(showRecipeDetailView:forView:)]) {
        [_delegate performSelector:@selector(showRecipeDetailView:forView:) withObject:nil withObject:self];
    }
}

#pragma mark - Core Grahics

- (void)drawRect:(CGRect)rect {
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSaveGState(currentContext);
    CGContextSetShadow(currentContext, CGSizeMake(0, 0), 5);
    
    // draw the rect
    CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, 200, 200);
    CGContextSetRGBFillColor(currentContext, 255, 255, 255, 1);
    CGContextFillRect(currentContext, newRect);
    
    CGContextRestoreGState(currentContext);
}

@end
