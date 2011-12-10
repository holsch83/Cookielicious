//
//  CLFlipView.m
//  Cookielicious
//
//  Created by Mauricio Hanika on 10.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import "CLShadowView.h"

@implementation CLShadowView

@synthesize delegate;

#pragma mark - Touch events

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if([delegate respondsToSelector:@selector(hideRecipeDetailView)]) {
        [delegate performSelector:@selector(hideRecipeDetailView)];
    }
}

#pragma mark - Object initialization

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
