//
//  CustomNavigationController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/7/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "CustomNavigationController.h"
#import "UIView+PWCategory.h"
#import "PhotoAlbumViewController.h"

@implementation CustomNavigationController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationBar] setHidden:YES];
}

-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController * sourceViewController = [self topViewController];
    
    UIView * sourceView = [sourceViewController view];
    UIView * sourceViewImage = [sourceView pw_imageSnapshot];
    
    UIImageView * sourceImageView = [[UIImageView alloc] initWithImage:sourceViewImage];
    
    BOOL isLandscape = UIInterfaceOrientationIsLandscape([sourceViewController interfaceOrientation]);
    
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    
    CGFloat statusBarHeight;
    
    if ( isLandscape )
    {
        statusBarHeight = statusBarFrame.size.width;
    }
    else
    {
        statusBarHeight = statusBarFrame.size.height;
    }
    
    CGRect newFrame = CGRectOffset([sourceImageView frame], 0, -statusBarHeight);
    
    [sourceImageView setFrame:newFrame];
    
    NSArray * viewControllers = [self viewControllers];
    
    NSInteger count = [viewControllers count];
    
    NSInteger index = count - 2;
    
    UIViewController * destinationViewController;
    
    destinationViewController = [viewControllers objectAtIndex:index];
    
    UIView * destinationView = [destinationViewController view];
    
    UIImage * destinationViewImage = [destinationView pw_imageSnapshot];
    
    UIImageView * destinationImageView = [[UIImageView alloc] initWithImage:destinationViewImage];
    
    [super popViewControllerAnimated:NO];
    
    [destinationView addSubview:destinationImageView];
    [destinationView addSubview:sourceImageView];
    
    CGRect selectedCellFrame = CGRectZero;
    
    for(id childviewController in [destinationViewController childViewControllers] )
    {
        if ( [childviewController isKindOfClass:[PhotoAlbumViewController class]] )
        {
            selectedCellFrame = [childviewController selectedCellFrame];
            break;
        }
    }
    
    
    CGPoint shrinkToPoint = CGPointMake(CGRectGetMidX(selectedCellFrame), CGRectGetMidY(selectedCellFrame));
    
    void(^animations)(void) = ^{
      
        [sourceImageView setFrame:CGRectMake(shrinkToPoint.x, shrinkToPoint.y, 0, 0)];
        
        [sourceImageView setAlpha:0.0];
        
        UINavigationBar * navBar = [self navigationBar];
        
        [navBar setFrame:CGRectOffset(navBar.frame, 0, -navBar.frame.size.height)];
        
    };
    
    void(^completion)(BOOL) = ^(BOOL finished) {
      
        [self setNavigationBarHidden:YES];
        
        UINavigationBar * navBar = [self navigationBar];
        
        [navBar setFrame:CGRectOffset(navBar.frame, 0, navBar.frame.size.height)];
        
        [sourceImageView removeFromSuperview];
        
        [destinationImageView removeFromSuperview];
        
    };
    
    
    [UIView transitionWithView:destinationView duration:0.3 options:UIViewAnimationOptionTransitionNone animations:animations completion:completion];
    
    return sourceViewController;
    
}


@end
