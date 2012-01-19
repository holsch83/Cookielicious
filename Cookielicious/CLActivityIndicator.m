//
//  SHKActivityIndicator.m
//  ShareKit
//
//  Created by Nathan Weiner on 6/16/10.

//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//

#import "CLActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define CLdegreesToRadians(x) (M_PI * x / 180.0)

@implementation CLActivityIndicator

@synthesize centerView = _centerView;
@synthesize subMessageLabel = _subMessageLabel;

static CLActivityIndicator *_currentIndicator = nil;

+ (CLActivityIndicator *)currentIndicator
{
	if (_currentIndicator == nil)
	{
		UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];		
		CGFloat width = 160;
		CGFloat height = 160;
		CGRect centeredFrame = CGRectMake(round(keyWindow.bounds.size.width/2 - width/2),
                                      round(keyWindow.bounds.size.height/2 - height/2),
                                      width,
                                      height);
		
		_currentIndicator = [[super allocWithZone:NULL] initWithFrame:centeredFrame];
		
		_currentIndicator.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
		_currentIndicator.opaque = NO;
		_currentIndicator.alpha = 0;		
		_currentIndicator.layer.cornerRadius = 10;		
		_currentIndicator.userInteractionEnabled = NO;
		_currentIndicator.autoresizesSubviews = YES;
		_currentIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin |  UIViewAutoresizingFlexibleBottomMargin;
		[_currentIndicator setProperRotation:NO];
		
		[[NSNotificationCenter defaultCenter] addObserver:_currentIndicator
                                             selector:@selector(setProperRotation)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
	}
	
	return _currentIndicator;
}

#pragma mark - Creating Message

- (void)show
{	
	if ([self superview] != [[UIApplication sharedApplication] keyWindow]) 
		[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
	
  [UIView animateWithDuration:0.3 animations:^{
    self.alpha = 1;
  }];
}

- (void)hideAfterDelay:(float)delay
{
	[self performSelector:@selector(hide) withObject:nil afterDelay:delay];
}

- (void)hide
{
  [UIView animateWithDuration:0.4 animations:^{
    self.alpha = 0;
  } completion:^(BOOL finished) {
    [self hidden];
  }];
}

- (void)hidden
{
	if (_currentIndicator.alpha > 0)
		return;
	
	[_currentIndicator removeFromSuperview];
}

- (void)setCenterView:(UIView *)view
{	
	if (view == nil && _centerView != nil) {
    [_centerView removeFromSuperview];
    _centerView = nil;
  }
  else {
    NSLog(@"Setting center view. Exists old center view: %d", [self centerView] != nil);
    if (_centerView != nil) {
      [_centerView removeFromSuperview];
      _centerView = nil;
    }
    
    _centerView = view;
    
    float x = (self.frame.size.width - view.frame.size.width) / 2;
    float y = (self.frame.size.height - view.frame.size.height) / 2;
    
    CGRect rect = CGRectMake(x, y, view.frame.size.width, view.frame.size.height);
    
    [view setFrame:rect];
    [self addSubview:view];
  }
}

- (void)setSubMessage:(NSString *)message
{	
	if (message == nil && _subMessageLabel != nil)
		self.subMessageLabel = nil;
	
	else if (message != nil)
	{
		if (_subMessageLabel == nil)
		{
			self.subMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,self.bounds.size.height-45,self.bounds.size.width-24,30)];
			_subMessageLabel.backgroundColor = [UIColor clearColor];
			_subMessageLabel.opaque = NO;
			_subMessageLabel.textColor = [UIColor whiteColor];
			_subMessageLabel.font = [UIFont boldSystemFontOfSize:12];
			_subMessageLabel.textAlignment = UITextAlignmentCenter;
			_subMessageLabel.shadowColor = [UIColor darkGrayColor];
			_subMessageLabel.shadowOffset = CGSizeMake(1,1);
			_subMessageLabel.adjustsFontSizeToFitWidth = NO;
			
			[self addSubview:_subMessageLabel];
		}
		
		_subMessageLabel.text = message;
	}
}

#pragma mark -
#pragma mark Rotation

- (void)setProperRotation
{
	[self setProperRotation:YES];
}

- (void)setProperRotation:(BOOL)animated
{
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	if (animated)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
	}
	
	if (orientation == UIInterfaceOrientationPortraitUpsideDown)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CLdegreesToRadians(180));	
	
	else if (orientation == UIInterfaceOrientationPortrait)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CLdegreesToRadians(0)); 
	
	else if (orientation == UIInterfaceOrientationLandscapeRight)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CLdegreesToRadians(90));	
	
	else if (orientation == UIInterfaceOrientationLandscapeLeft)
		self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CLdegreesToRadians(-90));
	
	if (animated)
		[UIView commitAnimations];
}

@end
