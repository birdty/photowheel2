//
//  MainViewController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/9/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoAlbumViewController.h"
#import "PhotoAlbumsViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (nonatomic, assign) BOOL skipRotation;

@end

@implementation MainViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext * mangedObjectContext = [appDelegate managedObjectContext];
    
    UIStoryboard * storyBoard = [self storyboard];
  
    UINavigationController * navController = [self  navigationController];
    UINavigationBar * navBar = [navController navigationBar];
    [navBar setFrame:CGRectOffset(navBar.frame, 0, -navBar.frame.size.height)];

    // add photo albums scene
    
    PhotoAlbumsViewController * photoAlbumsScene;
    
    photoAlbumsScene = [storyBoard instantiateViewControllerWithIdentifier:@"PhotoAlbumsScene"];
    
    [photoAlbumsScene setManagedObjectContext:mangedObjectContext];
    
    [self addChildViewController:photoAlbumsScene];
    
    [photoAlbumsScene didMoveToParentViewController:self];
    
    // add photo album scene
    
    PhotoAlbumViewController * photoAlbumScene;
    
    photoAlbumScene = [storyBoard instantiateViewControllerWithIdentifier:@"PhotoAlbumScene"];
        
    [self addChildViewController:photoAlbumScene];
    
    [photoAlbumScene didMoveToParentViewController:self];
    
    [photoAlbumsScene setPhotoAlbumViewController:photoAlbumScene];
    
    [self setSkipRotation:YES];
}

-(void)buttonPushed
{
    [self performSegueWithIdentifier:@"simpleSegue" sender:self];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(void)layoutForLandScape
{
    UIImage * image = [UIImage imageNamed:@"background-landscape-right-grooved.png"];
    
    [[self backgroundImageView2] setImage:image];
    
    CGRect frame = [self backgroundImageView2].frame;
    
    frame.size.width = 1024;
    frame.size.height = 768;
    
    [[self backgroundImageView2] setFrame:frame];
    
}

-(void)layoutForPortrait
{
    UIImage * image = [UIImage imageNamed:@"background-portrait-grooved.png"];

    [[self backgroundImageView2] setImage:image];
    
    CGRect frame = [self backgroundImageView2].frame;
    
    frame.size.width = 768;
    frame.size.height = 1024;
    
    [[self backgroundImageView2] setFrame:frame];
}


-(void)viewDidUnload
{
    [self setBackgroundImageView2:nil];
    [super viewDidUnload];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        [self layoutForLandScape];
    }
    else
    {
        [self layoutForPortrait];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
/*
    if ( [self skipRotation] == NO )
    {
        UIInterfaceOrientation interfaceOrientation = [self interfaceOrientation];
        
        NSTimeInterval interval = 0.35;
        
        void(^animation)() = ^{
            
            [self willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:interval];
            
            for(UIViewController * childController in [self childViewControllers] )
            {
                [childController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:interval];
            }
        };
        
        [UIView animateWithDuration:interval animations:animation];
    }
    
    [self setSkipRotation:NO];
*/
    
    [self layoutForOrientation:[UIDevice currentDevice].orientation];
    
}

-(void)layoutForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSTimeInterval interval = 0.35;
    
    void(^animation)() = ^{
        
        NSArray * childControllers = [self childViewControllers];
        
        PhotoAlbumsViewController * firstChild = childControllers[0];
        
        PhotoAlbumViewController * secondChild = childControllers[1];
        
        [firstChild willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:interval];
        
        [secondChild willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:interval];
    };
    
    [UIView animateWithDuration:interval animations:animation];
    
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation))
    {
        [self layoutForLandScape];
    }
    else
    {
        [self layoutForPortrait];
    }
}

@end
