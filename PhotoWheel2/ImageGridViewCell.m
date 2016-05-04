//
//  ImageGridViewCell.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/12/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "ImageGridViewCell.h"

@interface ImageGridViewCell ()

@property (nonatomic, strong, readwrite) UIImageView * imageView;

@end

@implementation ImageGridViewCell

-(void)commonInitWithSize:(CGSize)size
{
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    self.imageView = [[UIImageView alloc] initWithFrame:frame];
    
    [self addSubview:[self imageView]];
    
    NSInteger baseSize = 29;
    
    UIImage * selectedIndicatorImage = [UIImage imageNamed:@"addphoto.png"];
    
    self.selectedIndicator = [[UIImageView alloc] initWithImage:selectedIndicatorImage];

    CGRect bottomRightFrame = CGRectMake(
        size.width - baseSize - 4,
        size.height - baseSize - 4,
        baseSize,
        baseSize
    );

    [self.selectedIndicator setFrame:bottomRightFrame];
    
    [self.selectedIndicator setHidden:YES];
        
    [self addSubview:self.selectedIndicator];
}

-(id)init
{
    CGSize size = CGSizeMake(100, 100);
    
    self = [self initWithSize:size];
    
    return self;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];  
    [[self selectedIndicator] setHidden:!selected];
}

+(ImageGridViewCell *)imageGridViewCellWithSize:(CGSize)size
{
    ImageGridViewCell * newCell = [[ImageGridViewCell alloc] initWithSize:size];
    return newCell;
}

-(id)initWithSize:(CGSize)size
{
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self commonInitWithSize:size];
    }
    
    return self;
}

@end
