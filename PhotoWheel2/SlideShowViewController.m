//
//  SlideShowViewController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/23/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "SlideShowViewController.h"
#import "PhotoBrowserViewController.h"

@interface SlideShowViewController ()

@end

@implementation SlideShowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setCurrentIndex:[self startIndex]];    
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}


-(void)setCurrentIndex:(NSInteger)rawNewCurrentIndex
{
    if (
        ( rawNewCurrentIndex == [self currentIndex] )
        &&
        ( [[[self view] subviews] count] != 0 )
        )
    {
        return;
    }
    
    NSInteger photoCount = [[self delegate] photoBrowserViewControllerNumberOfPhotos:nil];
    
    NSInteger newCurrentIndex = rawNewCurrentIndex;
    
    if ( newCurrentIndex >= photoCount )
    {
        newCurrentIndex = 0;
    }
    
    if ( newCurrentIndex < 0 )
    {
        newCurrentIndex = photoCount - 1;
    }
    
    // create a new image view for the current photo
    
    UIImage * newImage = [[self delegate] photoBrowserViewController:nil imageAtIndex:newCurrentIndex];
    
    UIImageView * newPhotoView = [[UIImageView alloc] initWithImage:newImage];
    
    [newPhotoView setContentMode:UIViewContentModeScaleAspectFit];
    [newPhotoView setFrame:[[self view] bounds]];
    [newPhotoView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
    
    if ( [self currentPhotoView] == nil )
    {
        [[self view] addSubview:newPhotoView];
    }
    else
    {
        NSInteger transitionOptions;
        
        if ( rawNewCurrentIndex > [self currentIndex] )
        {
            transitionOptions = UIViewAnimationOptionTransitionCurlUp;
        }
        else
        {
            transitionOptions = UIViewAnimationTransitionCurlDown;
        }
        
        [UIView transitionFromView:[self currentPhotoView] toView:newPhotoView duration:1.0 options:transitionOptions completion:^(BOOL finished) {
            
            
        }];
        
        [self setCurrentPhotoView:newPhotoView];
        
        _currentIndex = newCurrentIndex;
    }
}

@end
