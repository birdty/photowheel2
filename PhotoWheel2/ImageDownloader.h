//
//  ImageDownloader.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/22/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ImageDownloaderCompletionBlock)(UIImage * image, NSError *);


@interface ImageDownloader : NSObject <NSURLConnectionDelegate>

@property (nonatomic, strong, readonly) UIImage * image;

-(void)downloadImageAtURL:(NSURL *)URL completion:(ImageDownloaderCompletionBlock)completion;

@end
