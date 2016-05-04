//
//  PhotoBrowserPhotoView.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/18/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "PhotoBrowserPhotoView.h"
#import "PhotoBrowserViewController.h"

@interface PhotoBrowserPhotoView ()

@property (nonatomic, strong) UIImageView * imageView;

-(void)loadSubviewsWithFrame:(CGRect)frame;
-(BOOL)isZoomed;

@end


@implementation PhotoBrowserPhotoView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setDelegate:self];
        
        [self setMaximumZoomScale:5.0];
        
        [self setShowsHorizontalScrollIndicator:NO];
        
        [self setShowsVerticalScrollIndicator:NO];
        
        [self loadSubviewsWithFrame:frame];
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        UITapGestureRecognizer * doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapped:)];

        [doubleTap setNumberOfTapsRequired:2];

        [self addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        
        [tap requireGestureRecognizerToFail:doubleTap];
        
        [self addGestureRecognizer:tap];
    }
    
    return self;
}

-(void)loadSubviewsWithFrame:(CGRect)frame
{
    frame.origin = CGPointMake(0, 0);
    
    UIImageView * newImageView = [[UIImageView alloc] initWithFrame:frame];
    
    [newImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    
    [newImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    [self addSubview:newImageView];
    
    [self setImageView:newImageView];
}


-(BOOL)isZoomed
{
    return !([self zoomScale] == [self minimumZoomScale]);
}

-(CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    
    zoomRect.size.height = [self frame].size.height / scale;
    zoomRect.size.width = [self frame].size.width / scale;
    
    zoomRect.origin.x = center.x - (zoomRect.size.width / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    
    return  zoomRect;
}

-(void)zoomToLocation:(CGPoint)location
{
    float newScale;
    CGRect zoomRect;
    
    if ( [self isZoomed] )
    {
        zoomRect = [self bounds];
    }
    else
    {
        newScale = [self maximumZoomScale];
        zoomRect = [self zoomRectForScale:newScale withCenter:location];
    }
    
    [self zoomToRect:zoomRect animated:YES];
}

-(void)turnOffZoom
{
    if ( [self isZoomed] )
    {
        [self zoomToLocation:CGPointZero];
    }
}

-(void)setImage:(UIImage *)newImage
{
    [[self imageView] setImage:newImage];
}


#pragma mark - Touch guestures

-(void)doubleTapped:(UITapGestureRecognizer *)recognizer
{
    [self zoomToLocation:[recognizer locationInView:self]];
}

-(void)tapped:(UITapGestureRecognizer *)recognizer
{
    [[self photoBrowserViewController] toggleChromeDisplay];
}

#pragma  mark - UIScrollViewDelegate methods

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [self imageView];
}

-(CGPoint)pointToCenterAfterRotation
{
    CGPoint boundsCenter = CGPointMake(
        CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds)
    );
    
    return [self convertPoint:boundsCenter toView:[self imageView]];
}

-(CGFloat)scaleToRestoreAfterRotation
{
    CGFloat contentScale = self.zoomScale;
    
    if ( contentScale <= self.minimumZoomScale + FLT_EPSILON )
    {
        contentScale = 0;
    }
    
    return contentScale;
}

-(CGPoint)maximumContentOffset
{
    CGSize contentSize = self.contentSize;
    CGSize boundsSize = self.bounds.size;
    
    return CGPointMake(contentSize.width - boundsSize.width, contentSize.height - boundsSize.height);
    
}

-(CGPoint)minimumContentOffset
{
    return CGPointZero;
}

-(void)setMaxMinZoomScaleForCurrentBounds
{
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = [[self imageView] bounds].size;
    
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    
    CGFloat minScale = MIN(xScale, yScale);
    
    CGFloat maxScale = 1.0 / [[UIScreen mainScreen] scale];
    
    if ( minScale > maxScale )
    {
        minScale = maxScale;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}

-(void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale
{
    self.zoomScale = MIN(self.maximumZoomScale, MAX(self.minimumZoomScale, oldScale));
    
    CGPoint boundsCenter = [self convertPoint:oldCenter fromView:[self imageView]];
    
    CGPoint offset = CGPointMake(boundsCenter.x - self.bounds.size.width / 2.0, boundsCenter.y - self.bounds.size.height / 2.0);
    
    CGPoint maxOffset = [self maximumContentOffset];
    
    CGPoint minOffset = [self minimumContentOffset];
    
    offset.x = MAX(minOffset.x, MIN(maxOffset.x, offset.x));
    offset.y = MAX(minOffset.y, MIN(maxOffset.y, offset.y));
    
    self.contentOffset = offset;
}


@end
