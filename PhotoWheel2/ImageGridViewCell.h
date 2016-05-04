//
//  ImageGridViewCell.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/12/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "GridView.h"

@interface ImageGridViewCell : GridViewCell

@property (nonatomic, strong, readonly) UIImageView * imageView;
@property (nonatomic, strong) UIImageView * selectedIndicator;

+(ImageGridViewCell *)imageGridViewCellWithSize:(CGSize)size;
-(id)initWithSize:(CGSize)size;


@end
