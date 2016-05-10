//
//  FlickrManager.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 1..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "FlickrManager.h"

@implementation FlickrManager

NSString *APIKey = @"d1b46134961538a691cc649e63476d0d";
NSString *APISecret = @"b44292a995535ad3";

NSString *OAuthToken = @"72157637498723594-aea58e39252893a2";
NSString *OAuthSecret = @"4787600430c4fb3e";

static FlickrManager *__sharedInstance = nil;

+ (FlickrManager *)sharedInstance
{
    @synchronized(self)
    {
        if(__sharedInstance == nil)
        {
            __sharedInstance = [[self alloc] init];
        }
    }
    return __sharedInstance;
}

- (id)init
{
    if(self = [super init])
    {
        flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:APIKey sharedSecret:APISecret];
        [flickrContext setOAuthToken:OAuthToken];
        [flickrContext setOAuthTokenSecret:OAuthSecret];
    }
    return self;
}

- (NSString *)getAPIKey
{
    return APIKey;
}

- (OFFlickrAPIContext *)getFlickrContext
{
    return flickrContext;
}

@end
