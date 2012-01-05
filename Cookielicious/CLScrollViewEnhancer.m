//
//  ScrollViewEnhancer_iPad.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLScrollViewEnhancer.h"

@implementation CLScrollViewEnhancer


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
	if ([self pointInside:point withEvent:event]) {
		return _scrollView;
	}
	return nil;
}

@end
