//
//  FlickrViewController.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/22/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GridView.h"

@interface FlickrViewController : UIViewController <GridViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet GridView * gridView;
@property (nonatomic, strong) IBOutlet UIView * overlayView;
@property (nonatomic, strong) IBOutlet UISearchBar * searchBar;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) NSManagedObjectID * objectID;

-(IBAction)save:(id)sender;
-(IBAction)cancel:(id)sender;

@end
