//
//  CLFavoriteCell.h
//  Cookielicious
//
//  Created by Orlando Schäfer on 17.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLFavoriteCell : UITableViewCell 

@property (nonatomic, strong) IBOutlet UIImageView *previewImage;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;

@end
