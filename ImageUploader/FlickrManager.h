//
//  FlickrManager.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 1..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ObjectiveFlickr.h"

@interface FlickrManager : NSObject
{
    OFFlickrAPIContext *flickrContext;
}

+ (FlickrManager *)sharedInstance;
- (OFFlickrAPIContext *)getFlickrContext;
- (NSString *)getAPIKey;
@end
