
//
//  MainSlideShowViewController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/23/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "MainSlideShowViewController.h"
#import "PhotoBrowserViewController.h"
#import "SlideShowViewController.h"
#import "ClearToolbar.h"

@interface MainSlideShowViewController ()

@property (nonatomic, strong) NSTimer * slideAdvanceTimer;
@property (nonatomic, assign, getter = isChromeHidden) BOOL chromeHidden;
@property (nonatomic, strong) NSTimer * chromeHideTimer;
@property (nonatomic, strong) SlideShowViewController * externalDisplaySlideshowController;

@property (nonatomic, strong) UIWindow * externalScreenWindow;

@end

@implementation MainSlideShowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(advanceSlide:) userInfo:nil repeats:YES];
    
    [self setSlideAdvanceTimer:timer];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self cancelChromeDisplayTimer];
    [[self slideAdvanceTimer] invalidate];
    [self setSlideAdvanceTimer:nil];
    [self setExternalDisplaySlideshowController:nil];
    [self setExternalScreenWindow:nil];
}

-(void)advanceSlide:(NSTimer *)timer
{
    [self setCurrentIndex:[self currentIndex] + 1];
}

-(void)cancelChromeDisplayTimer
{
    [[self chromeHideTimer] invalidate];
}

-(void)updateNavBarButtonsForPlayingState:(BOOL)playing
{
    UIBarButtonItem * rewindButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(backOnePhoto:)];
    
    [rewindButton setStyle:UIBarButtonItemStyleBordered];
    
    UIBarButtonItem * playPauseButton;
    
    if ( playing )
    {
        playPauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause:)];
        
    }
    else
    {
        playPauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(resume:)];
        
    }
    
    
    [playPauseButton setStyle:UIBarButtonItemStyleBordered];
    
    UIBarButtonItem * forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(forwardOnePhoto:)];
    
    [forwardButton setStyle:UIBarButtonItemStyleBordered];
    
    NSArray * toolbarItems = [NSArray arrayWithObjects:rewindButton, playPauseButton, forwardButton, nil];
    
    UIToolbar * toolbar = [[ClearToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    
    [toolbar setBackgroundColor:[UIColor clearColor]];
    
    [toolbar setBarStyle:UIBarStyleBlack];
    
    [toolbar setTranslucent:YES];
    
    [toolbar setItems:toolbarItems];
    
    UIBarButtonItem * customBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:toolbar];
    
    [[self navigationItem] setRightBarButtonItem:customBarButtonItem animated:YES];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateNavBarButtonsForPlayingState:YES];
    
    UIScreen * externalScreen = [self getExternalScreen];
    
    if ( externalScreen != nil )
    {
        [self configureExternalScreen:externalScreen];
    }
    
    NSNotificationCenter * notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserverForName:UIScreenDidConnectNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note ) {
        
        UIScreen * newExternalScreen = [note object];
        
        [self configureExternalScreen:newExternalScreen];
        
    }];
    
    [notificationCenter addObserverForName:UIScreenDidDisconnectNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * note ) {
        
        [self setExternalDisplaySlideshowController:nil];
        [self setExternalScreenWindow:nil];
        
    }];
    
    
}

-(void)setCurrentIndex:(NSInteger)currentIndex
{
    [super setCurrentIndex:currentIndex];
    
    [[self externalDisplaySlideshowController] setCurrentIndex:currentIndex];
    
    [[self currentPhotoView] setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer * photoTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(photoTapped:)];
    
    [[self currentPhotoView] addGestureRecognizer:photoTapRecognizer];
}


-(UIScreen *)getExternalScreen
{
    NSArray * screens = [UIScreen screens];
    
    UIScreen * externalScreen = nil;
    
    if ( [screens count] > 1 )
    {
        externalScreen = [screens lastObject];
    }
    
    return externalScreen;
}


-(void)configureExternalScreen:(UIScreen *)externalScreen
{
    [self setExternalDisplaySlideshowController:nil];
    [self setExternalScreenWindow:nil];
    
    // create a new window and move it to the external screen
    
    [self setExternalScreenWindow:[[UIWindow alloc] initWithFrame:[externalScreen applicationFrame]]];
    
    [[self externalScreenWindow] setScreen:externalScreen];
     
    SlideShowViewController * externalSlideController = [[SlideShowViewController alloc] init];
    
    [self setExternalDisplaySlideshowController:externalSlideController];
    
    [externalSlideController setDelegate:[self delegate]];
    
    [externalSlideController setStartIndex:[self currentIndex]];
    
    [[self externalScreenWindow] addSubview:[externalSlideController view]];
    
    [[externalSlideController view] setFrame:[[self externalScreenWindow] frame]];
    
    [[externalSlideController view] setBackgroundColor:[[self view] backgroundColor]];
    
    [[self externalScreenWindow] makeKeyAndVisible];
}

-(void)pause:(id)sender
{
    [[self slideAdvanceTimer] setFireDate:[NSDate distantFuture]];
    [self updateNavBarButtonsForPlayingState:NO];
}

-(void)resume:(id)sender
{
    [[self slideAdvanceTimer] setFireDate:[NSDate date]];
    [self updateNavBarButtonsForPlayingState:YES];
}

-(void)backOnePhoto:(id)sender
{
    [self pause:nil];
    [self setCurrentIndex:[self currentIndex] - 1];
}

-(void)forwardOnePhoto:(id)sender
{
    [self pause:nil];
    [self setCurrentIndex:[self currentIndex] + 1];
}


@end
