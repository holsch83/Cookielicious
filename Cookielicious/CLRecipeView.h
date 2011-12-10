//
//  CLRecipeView.h
//  Cookielicious
//
//  Created by Mauricio Hanika on 07.12.11.
//  Copyright (c) 2011 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CLRecipeView : UIView 

@property(nonatomic, strong) id <NSObject> delegate;
@property(nonatomic, strong) IBOutlet UILabel *titleLabel;

@end
