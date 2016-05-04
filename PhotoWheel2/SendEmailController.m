//
//  SendEmailController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/21/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "SendEmailController.h"
#import "Photo.h"

@implementation SendEmailController

-(id)initWithViewController:(UIViewController<SendEmailControllerDelegate> *)viewController
{
    self = [super init];
    
    if ( self )
    {
        [self setViewController:viewController];
    }
    
    return self;
}

-(void)sendEmail
{
    MFMailComposeViewController * mailer = [[MFMailComposeViewController alloc] init];
    
    [mailer setMailComposeDelegate:self];
    
    [mailer setSubject:@"Pictures from PhotoWheel"];
    
    __block NSInteger index = 0;
    
    [[self photos] enumerateObjectsUsingBlock:^(id photo, BOOL * stop )
    {
        index++;
        
        UIImage * image;
        
        if ( [photo isKindOfClass:[UIImage class]] )
        {
            image = photo;
        }
        else
        {
            image = [photo originalImage];
        }
        
        if ( image )
        {
            NSData * imageData = UIImageJPEGRepresentation(image, 1.0);
            
            NSString * fileName = [NSString stringWithFormat:@"photo-%1", index];
            
            [mailer addAttachmentData:imageData mimeType:@"image/jpeg" fileName:fileName];
        }
        
    }];
    
    [[self viewController] presentModalViewController:mailer animated:YES];
}


-(void)mailComposeController:(MFMailComposeViewController*)controller
didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    UIViewController<SendEmailControllerDelegate> * viewController = [self viewController];
    
    if ( viewController && [viewController respondsToSelector:@selector(sendEmailControllerDidFinish:)])
    {
        [viewController sendEmailControllerDidFinish:self];
    }
}


+(BOOL)canSendEmail
{
    return [MFMailComposeViewController canSendMail];
}

@end
