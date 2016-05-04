//
//  CustomPushSegue.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/7/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "CustomPushSegue.h"
#import "UIView+PWCategory.h"
#import "PhotoAlbumViewController.h"

@implementation CustomPushSegue


-(void)perform
{
    id sourceViewController = [self sourceViewController];
    
    UIView * sourceView =  [[[self sourceViewController] parentViewController] view];
    
    UIView * destinationView = [[self destinationViewController] view];
    
    UIImageView * sourceImageView;
    
    sourceImageView = [[UIImageView alloc] initWithImage:[sourceView pw_imageSnapshot]];
    
    BOOL isLandScape = UIInterfaceOrientationIsLandscape([sourceViewController interfaceOrientation]);
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    CGFloat statusBarHeight;
    
    if ( isLandScape )
    {
        statusBarHeight = statusBarFrame.size.width;
    }
    else
    {
        statusBarHeight = statusBarFrame.size.height;
    }
    
    CGRect newFrame = CGRectOffset([sourceImageView frame], 0, statusBarHeight);
    
    CGRect destinationFrame = [[UIScreen mainScreen] bounds];
    
    if ( isLandScape )
    {
        destinationFrame.size = CGSizeMake(destinationFrame.size.height, destinationFrame.size.width);
    }
    
    UIImage * destinationImage = [sourceViewController selectedImage];
    
    UIView * destinationImageView = [[UIImageView alloc] initWithImage:destinationImage];
    
    [destinationImageView setContentMode:UIViewContentModeScaleAspectFit];
    [destinationImageView setBackgroundColor:[UIColor blackColor]];
    [destinationImageView setFrame:[sourceViewController selectedCellFrame]];
    [destinationImageView setAlpha:0.3];
    
    UINavigationController * navController;
    
    navController = [[self sourceViewController] navigationController];
    
    [navController pushViewController:[self destinationViewController] animated:NO];
    
    UINavigationBar * navBar = [navController navigationBar];
    
    [navController setNavigationBarHidden:NO];
    
    [navBar setFrame:CGRectOffset(navBar.frame, 0, -navBar.frame.size.height)];
    
    [destinationView addSubview:sourceImageView];
    [destinationView addSubview:destinationImageView];
    
    void(^animations)(void) = ^{
      
        [destinationImageView setFrame:destinationFrame];
        
        [destinationImageView setAlpha:1.0];
        
        [navBar setFrame:CGRectOffset(navBar.frame, 0, navBar.frame.size.height)];
        
        [navBar setHidden:NO];
        
        NSLog(@"should have shown navigation bar!");
        
    };
    

    void(^completion)(BOOL) = ^(BOOL finished) {
      
        if ( finished )
        {
            [sourceImageView removeFromSuperview];
            [destinationImageView removeFromSuperview];
        }
        
    };
    
    [UIView animateWithDuration:0.6 animations:animations completion:completion];
}


@end
