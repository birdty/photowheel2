//
//  PhotoBrowserViewController.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/14/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SendEmailController.h"

@protocol PhotoBrowserViewControllerDelegate;

@interface PhotoBrowserViewController : UIViewController <UIScrollViewDelegate, PhotoBrowserViewControllerDelegate, UIActionSheetDelegate, SendEmailControllerDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) id<PhotoBrowserViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger startAtIndex;

@property (nonatomic, strong) SendEmailController * sendEmailController;

-(void)toggleChromeDisplay;

@property (strong, nonatomic) IBOutlet UIView * filterViewContainer;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray * filterButtons;

-(IBAction)enhanceImage:(id)sender;
-(IBAction)zoomToFaces:(id)sender;
-(IBAction)applyFilter:(id)sender;

-(IBAction)revertToOriginal:(id)sender;
-(IBAction)saveImage:(id)sender;
-(IBAction)cancel:(id)sender;


@end

@protocol PhotoBrowserViewControllerDelegate <NSObject>
@required

-(NSInteger)photoBrowserViewControllerNumberOfPhotos:(PhotoBrowserViewController *)photoBrowser;

-(UIImage *)photoBrowserViewController:(PhotoBrowserViewController *)photoBrowser imageAtIndex:(NSInteger) index;


-(UIImage *)photoBrowserViewController:(PhotoBrowserViewController *)photoBrowser smallImageAtIndex:(NSInteger)index;


-(void)photoBrowserViewController:(PhotoBrowserViewController *)photoBrowser deleteImageAtIndex:(NSInteger)index;

-(void)photoBrowserViewController:(PhotoBrowserViewController *)photoBrowser updateToNewImage:(UIImage *)image atIndex:(NSInteger)index;

@end
