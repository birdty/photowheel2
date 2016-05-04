//
//  FlickrViewController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/22/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "FlickrViewController.h"
#import "ImageGridViewCell.h"
#import "SimpleFlickrAPI.h"
#import "ImageDownloader.h"
#import "Photo.h"
#import "PhotoAlbum.h"

@interface FlickrViewController ()

@property (nonatomic, strong) NSArray * flickrPhotos;
@property (nonatomic, strong) NSMutableArray * downloaders;
@property (nonatomic, assign) NSInteger showOverlayCount;

@end

@implementation FlickrViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self overlayView] setAlpha:0.0];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(overlayViewTapped:)];
    
    [[self overlayView] addGestureRecognizer:tap];
    
    [[self gridView] setAlwaysBounceVertical:YES];
    
    [[self gridView] setAllowsMultipleSelection:YES];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

-(BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

#pragma mark - Save photos

-(void)saveContextAndExit
{
    NSManagedObjectContext * context = [self managedObjectContext];
    
    NSError * error = nil;
    
    if ( ! [context save:&error] )
    {
        
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveSelectedPhotos
{
    NSManagedObjectContext * context = [self managedObjectContext];
    
    id photoAlbum = [context objectWithID:[self objectID]];
    
    NSArray * indexes = [[self gridView] indexesForSelectedCells];
    
    __block NSInteger count = [indexes count];
    
    if ( count == 0 )
    {
        [self dismissModalViewControllerAnimated:YES];
        return;
    }
    
    ImageDownloaderCompletionBlock completion = ^(UIImage * image, NSError * error)
    {
        if ( image )
        {
            Photo * newPhoto = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:context];
            
            [newPhoto setDateAdded:[NSDate date]];
            [newPhoto saveImage:image];
            [newPhoto setPhotoAlbum:photoAlbum];
        }
        else
        {
            NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
        }
        
        count--;
        
        if ( count == 0 )
        {
            [self saveContextAndExit];
        }
    };
    
    for(NSNumber * indexNumber in indexes )
    {
        NSInteger index = [indexNumber integerValue];
        
        NSDictionary * flickrPhoto = [[self flickrPhotos] objectAtIndex:index];
        
        NSURL * URL = [NSURL URLWithString:[flickrPhoto objectForKey:@"url_m"]];

        ImageDownloader * downloader = [[ImageDownloader alloc] init];
        
        [downloader downloadImageAtURL:URL completion:completion];
        
        [[self downloaders] addObject:downloader];
    }
}

-(IBAction)save:(id)sender
{
    [[self overlayView] setUserInteractionEnabled:NO];
    
    void(^animations)(void) = ^{
      
        [[self overlayView] setAlpha:0.4];
        
        [[self activityIndicator] startAnimating];
        
    };
    
    [UIView animateWithDuration:0.2 animations:animations];
    
    [self saveSelectedPhotos];
}

-(IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Overlay methods

-(void)showOverlay:(BOOL)showOverlay
{
    BOOL isVisible = ([[self overlayView] alpha] > 0.0);
    
    if ( isVisible != showOverlay )
    {
        CGFloat alpha = showOverlay ? 0.4 : 0.0;
        
        void(^animations)(void) = ^{
          
            
            [[self overlayView] setAlpha:alpha];
            
            [[self searchBar] setShowsCancelButton:showOverlay animated:YES];
        };
        
        void(^completion)(BOOL) = ^(BOOL finished) {
          
            if ( finished )
            {
                
            }
            
        };
        
        [UIView animateWithDuration:0.2 animations:animations completion:completion];
    }
}

-(void)showOverlay
{
    self.showOverlayCount += 1;
    
    BOOL showOverlay = (self.showOverlayCount > 0 );
    
    [self showOverlay:showOverlay];
}


-(void)hideOverlay
{
    self.showOverlayCount -= 1;
    
    BOOL showOverlay = (self.showOverlayCount > 0);
    
    [self showOverlay:showOverlay];
    
    if ( self.showOverlayCount < 0 )
    {
        self.showOverlayCount = 0;
    }
}

-(void)overlayViewTapped:(UITapGestureRecognizer *)recognizer
{
    [self hideOverlay];
    [[self searchBar] resignFirstResponder];
}

#pragma mark - Flickr

-(void)fetchFlickrPhotosWithSearchString:(NSString *)searchString
{
    [[self activityIndicator] startAnimating];
    
    [self showOverlay];
    
    [[self overlayView] setUserInteractionEnabled:NO];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
    ^{
    
        SimpleFlickrAPI * flickr = [[SimpleFlickrAPI alloc] init];
        
        NSArray * photos = [flickr photosWithSearchString:searchString];
        
        NSMutableArray * downloaders = [[NSMutableArray alloc] initWithCapacity:[photos count]];
        
        for(NSInteger index = 0; index < [photos count]; index++)
        {
            ImageDownloader * downloader = [[ImageDownloader alloc] init];
            
            [downloaders addObject:downloader];
        }
        
        [self setDownloaders:downloaders];
        
        [self setFlickrPhotos:photos];
    
        dispatch_async(dispatch_get_main_queue(), ^{
        
            [[self gridView] reloadData];
            
            [self hideOverlay];
            
            [[self overlayView] setUserInteractionEnabled:YES];
            
            [[self searchBar] resignFirstResponder];
            
            [[self activityIndicator] stopAnimating];

        });
        
    });
}


#pragma mark - UISearchBarDelegate methods

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self showOverlay];
    
    return YES;
}


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self hideOverlay];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self fetchFlickrPhotosWithSearchString:[searchBar text]];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self hideOverlay];
}


#pragma mark - GridViewDataSource methods

-(NSInteger)gridViewNumberOfCells:(GridView *)gridView
{
    NSInteger count = [[self flickrPhotos] count];
    
    return count;
}

-(GridViewCell *)gridView:(GridView *)gridView cellAtIndex:(NSInteger)index
{
    ImageGridViewCell * cell = [gridView dequeueReusableCell];
    
    if ( cell == nil )
    {
        cell = [ImageGridViewCell imageGridViewCellWithSize:CGSizeMake(75, 75)];
        
        [[cell selectedIndicator] setImage:[UIImage imageNamed:@"addphoto.png"]];
    }
    
    ImageDownloaderCompletionBlock completion = ^(UIImage * image, NSError * error) {
      
        if ( image )
        {
            [[cell imageView] setImage:image];
        }
        else
        {
            NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
        }
        
    };
    
    ImageDownloader * downloader = [[self downloaders] objectAtIndex:index];
    
    UIImage * image = [downloader image];
    
    
    if ( image )
    {
        [[cell imageView] setImage:image];
    }
    else
    {
        NSDictionary * flickrPhoto = [[self flickrPhotos] objectAtIndex:index];
        
        NSURL * URL = [NSURL URLWithString:[flickrPhoto objectForKey:@"url_sq"]];
        
        [downloader downloadImageAtURL:URL completion:completion];
    }
    
    return cell;
}


-(CGSize)gridViewCellSize:(GridView *)gridView
{
    return CGSizeMake(75, 75);
}

-(void)gridView:(GridView *)gridView didSelectCellAtIndex:(NSInteger)index
{
    id cell = [gridView cellAtIndex:index];
    
    [cell setSelected:YES];
}

-(void)gridView:(GridView *)gridView didDeselectCellAtIndex:(NSInteger)index
{
    id cell = [gridView cellAtIndex:index];
    
    [cell setSelected:NO];
}

@end


