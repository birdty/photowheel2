//
//  PhotoAlbumsViewController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/9/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "PhotoAlbumsViewController.h"
#import "PhotoWheelViewCell.h"
#import "PhotoAlbum.h"
#import "Photo.h"
#import "PhotoAlbumViewController.h"

@interface PhotoAlbumsViewController ()
@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic, strong) IBOutlet UIButton * addButton;
@end

@implementation PhotoAlbumsViewController

-(void)didMoveToParentViewController:(UIViewController *)parent
{
    [[parent view] addSubview:[self view]];
    
    CGRect newFrame = CGRectMake(109, 680, 551, 550);
    
    [[self view] setFrame:newFrame];
    
    [[self view] setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Actions

-(IBAction)addPhotoAlbum:(id)sender
{
    NSManagedObjectContext * context = [self managedObjectContext];
    
    PhotoAlbum * photoAlbum = [NSEntityDescription insertNewObjectForEntityForName:@"PhotoAlbum" inManagedObjectContext:context];
    
    [photoAlbum setDateAdded:[NSDate date]];
    
    NSError * error = nil;
    
    if ( ! [ context save:&error] )
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    else
    {
        NSLog(@"added..");
    }
}

#pragma mark - NSFetchedReusultsController and NSFetchedResultsControllerDelegate

-(NSFetchedResultsController *)fetchedResultsController
{
    if ( _fetchedResultsController )
    {
        return _fetchedResultsController;
    }
    
    NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"PhotoAlbum"];
    
    NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"dateAdded" ascending:YES];
    
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSFetchedResultsController * newFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
    [newFetchedResultsController setDelegate:self];
    
    NSError * error = nil;
    
    if ( ! [newFetchedResultsController performFetch:&error] )
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self setFetchedResultsController:newFetchedResultsController];
    
    return _fetchedResultsController;
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [[self wheelView] reloadData];
}

#pragma mark - WheelViewDataSource and WheelViewDelegate methods

-(NSInteger)wheelViewNumberOfVisibleCells:(WheelView *)wheelView
{
    return 7;
}

-(NSInteger)wheelViewNumberOfCells:(WheelView *)wheelView
{
    NSArray * sections = [[self fetchedResultsController] sections];
    
    NSInteger count = [[sections objectAtIndex:0] numberOfObjects];
    
    return count;
}

-(WheelViewCell *)wheelView:(WheelView *)wheelView cellAtIndex:(NSInteger)index
{
    PhotoWheelViewCell * cell = [wheelView dequeueReusableCell];
    
    if ( ! cell )
    {
        cell = [PhotoWheelViewCell photoWheelViewCell];
    }
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    PhotoAlbum * photoAlbum;
    
    photoAlbum = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    
    Photo * photo = [[photoAlbum photos] lastObject];
    
    UIImage * image = [photo thumbnailImage];
    
    if ( image == nil )
    {
        image = [UIImage imageNamed:@"defaultPhoto.png"];
    }

    [[cell imageView] setImage:image];
    
    [[cell label] setText:[photoAlbum name]];
    
    return cell;
}

-(void)wheelView:(WheelView *)wheelView didSelectCellAtIndex:(NSInteger)index
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    PhotoAlbum * photoAlbum = nil;
    
    if ( index >= 0 )
    {
        photoAlbum = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    }
    
    PhotoAlbumViewController * photoAlbumViewController = [self photoAlbumViewController];
    
    [photoAlbumViewController setManagedObjectContext:[self managedObjectContext]];
    
    [photoAlbumViewController setObjectID:[photoAlbum objectID]];
    
    [photoAlbumViewController reload];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGRect newFrame;
    CGFloat angleOffset;
    
    if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        newFrame = CGRectMake(700, 100, 551, 550);
        angleOffset = 270.0;
    }
    else
    {
        newFrame = CGRectMake(109, 680, 551, 550);
        angleOffset = 0.0;
    }
    
    [[self view] setFrame:newFrame];
    [[self wheelView] setAngleOffset:angleOffset];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}


@end
