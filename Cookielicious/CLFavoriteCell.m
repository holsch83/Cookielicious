//
//  CLFavoriteCell.m
//  Cookielicious
//
//  Created by Orlando Schäfer on 17.01.12.
//  Copyright (c) 2012 cookcrowd. All rights reserved.
//

#import "CLFavoriteCell.h"

@implementation CLFavoriteCell

@synthesize previewImage = _previewImage;
@synthesize titleLabel = _titleLabel;
@synthesize dateLabel = _dateLabel;


- (NSString*)reuseIdentifier {

  return @"FavoriteCell";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
      // Initialization code
  }
  return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
