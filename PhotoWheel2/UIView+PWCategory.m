//
//  UIView+PWCategory.m
//  PhotoWheel2
//
//  Created by Tyler Bird on 4/7/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

#import "UIView+PWCategory.h"

@implementation UIView (PWCategory)

-(UIImage *)pw_imageSnapshot
{
    UIGraphicsBeginImageContext([self bounds].size);
    
    [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


@end
