//
//  ImageDownloader.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/22/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "ImageDownloader.h"

@interface ImageDownloader ()

@property (nonatomic, strong, readwrite) UIImage * image;
@property (nonatomic, strong) NSMutableData * receivedData;
@property (nonatomic, strong) ImageDownloaderCompletionBlock completion;

@end

@implementation ImageDownloader

-(void)downloadImageAtURL:(NSURL *)URL completion:(ImageDownloaderCompletionBlock)completion
{
    if (URL )
    {
        [self setCompletion:completion];
                
        [self setReceivedData:[[NSMutableData alloc] init]];
        
        NSURLRequest * request = [NSURLRequest requestWithURL:URL];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        
        [connection start];
    }
}

#pragma mark - NSURLConnection delegate methods

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(nonnull NSURLResponse *)response
{
    [[self receivedData] setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(nonnull NSData *)data
{
    [[self receivedData] appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self setImage:[UIImage imageWithData:[self receivedData]]];
    [self setReceivedData:nil];
    
    ImageDownloaderCompletionBlock completion = [self completion];
    
    completion([self image], nil);
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self setReceivedData:nil];
    
    ImageDownloaderCompletionBlock completion = [self completion];
    
    completion(nil, error);
}

@end
