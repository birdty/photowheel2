//
//  SlideShowViewController.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/23/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoBrowserViewControllerDelegate;

@interface SlideShowViewController : UIViewController

@property (nonatomic, strong) id<PhotoBrowserViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger startIndex;
@property (nonatomic, strong) UIView * currentPhotoView;

@end
