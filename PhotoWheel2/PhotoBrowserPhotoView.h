//
//  PhotoBrowserPhotoView.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/18/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoBrowserViewController;

@interface PhotoBrowserPhotoView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) PhotoBrowserViewController * photoBrowserViewController;

-(void)setImage:(UIImage *)newImage;
-(void)turnOffZoom;

-(CGPoint)pointToCenterAfterRotation;
-(CGFloat)scaleToRestoreAfterRotation;
-(void)setMaxMinZoomScaleForCurrentBounds;
-(void)restoreCenterPoint:(CGPoint)oldCenter scale:(CGFloat)oldScale;

@end
