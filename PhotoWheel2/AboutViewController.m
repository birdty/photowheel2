//
//  AboutViewController.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/7/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

-(IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
