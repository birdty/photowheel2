//
//  SendEmailController.h
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/21/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@protocol SendEmailControllerDelegate;

@interface SendEmailController : NSObject <SendEmailControllerDelegate>

@property (nonatomic, strong) UIViewController<SendEmailControllerDelegate> * viewController;

@property (nonatomic, strong) NSSet * photos;

-(id)initWithViewController:(UIViewController<SendEmailControllerDelegate> *)viewController;

-(void)sendEmail;

+(BOOL)canSendEmail;

@end


@protocol SendEmailControllerDelegate

@required

-(void)sendEmailControllerDidFinish:(SendEmailController *)controller;

@end
