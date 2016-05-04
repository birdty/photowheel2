//
//  PhotoAlbumsViewController.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/9/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "WheelView.h"

@class PhotoAlbumViewController;

@interface PhotoAlbumsViewController : UIViewController <NSFetchedResultsControllerDelegate, WheelViewDataSource, WheelViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) IBOutlet WheelView * wheelView;
@property (nonatomic, strong) PhotoAlbumViewController * photoAlbumViewController;

-(IBAction)addPhotoAlbum:(id)sender;

@end
