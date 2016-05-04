//
//  PhotoAlbumViewController.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/9/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "GridView.h"
#import "PhotoBrowserViewController.h"
#import "SendEmailController.h"

@interface PhotoAlbumViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, NSFetchedResultsControllerDelegate, GridViewDataSource, PhotoBrowserViewControllerDelegate, SendEmailControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext * managedObjectContext;
@property (nonatomic, strong) NSManagedObjectID * objectID;
@property (nonatomic, strong) UIToolbar * toolbar;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIBarButtonItem * addButton;

@property (nonatomic, strong) IBOutlet GridView * gridView;

@property (nonatomic, strong) IBOutlet UIImageView * backgroundImageView;
@property (nonatomic, strong) IBOutlet UIImageView * shadowImageView;

-(void)reload;
-(IBAction)showActionMenu:(id)sender;
-(IBAction)addPhoto:(id)sender;

-(UIImage *)selectedImage;
-(CGRect)selectedCellFrame;

@end
