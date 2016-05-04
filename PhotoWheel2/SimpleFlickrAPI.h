//
//  SimpleFlickrAPI.h
//  PhotoWheelPrototype
//
//  Created by Tyler Bird on 4/22/16.
//  Copyright © 2016 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleFlickrAPI : NSObject

-(NSArray *)photosWithSearchString:(NSString *)string;

-(NSString *)userIdForUsername:(NSString *)username;

-(NSArray *)photoSetListWithUserId:(NSString *)userId;

-(NSArray *)photosWithPhotoSetId:(NSString *)photoSetId;

@end
