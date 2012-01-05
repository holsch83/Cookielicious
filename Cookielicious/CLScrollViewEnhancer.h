//
//  CLScrollViewEnhancer.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 04.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 The ScrollViewEnhancer is used for detecting touch events and forwarding
 them to the scroll view, which is used for scrolling through the POI Details.
 
 With that we can use a Scroll view of smaller size to preview the POIs on the left
 and right hand side of the current POI.
 
 The ScrollViewEnhancer is on top of the scroll view and bigger than it. So it also
 detects touches, the scroll view would not.
 */
@interface CLScrollViewEnhancer : UIView {

  @private
  IBOutlet UIScrollView *_scrollView;
}

@end
