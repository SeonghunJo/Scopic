//
//  UserManager.m
//  Scopic
//
//  Created by 조 성훈 on 2013. 12. 19..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "UserManager.h"

@implementation UserManager
@synthesize userName, uploadPhotoList, likePhotoList;

static UserManager *__sharedInstance;

+ (UserManager *)sharedInstance
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

- (id) init
{
    if (self = [super init])
    {
        NSLog(@"UserManager Init");
        self.userName = [[NSString alloc] init];
        self.uploadPhotoList = [[NSMutableArray alloc] init];
        self.likePhotoList = [[NSMutableArray alloc] init];
        
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[FlickrManager sharedInstance].getFlickrContext];
        
        flickrRequest.delegate = self;
        [flickrRequest setRequestTimeoutInterval:60];
    }
    return self;
}

- (void)getUploadedPhotoInfoWithID:(NSString *)photoID
{
    [flickrRequest callAPIMethodWithPOST:@"flickr.photos.getInfo" arguments:[[NSDictionary alloc] initWithObjectsAndKeys:photoID, @"photo_id", nil]];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    //NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    //NSLog(@"%@ %@", inRequest.sessionInfo, inResponseDictionary);
    //NSLog(@"%@", [inResponseDictionary valueForKey:@"photos"]);
    
    /*
     NSDictionary *photos = [inResponseDictionary valueForKey:@"sizes"];
     NSArray *sizeArray = [photos valueForKey:@"size"];
     
     //NSLog(@"%@", [photos valueForKey:@"photo"]);
     for (NSDictionary *unit in sizeArray) {
     
     }
     */
    //secret="ce9ce179e2" server="7398" farm="8"
    NSDictionary *requestResult = [inResponseDictionary objectForKey:@"photo"];
    NSString *photoID = [requestResult objectForKey:@"id"];
    NSString *secret = [requestResult objectForKey:@"secret"];
    NSString *server = [requestResult objectForKey:@"server"];
    NSString *farm = [requestResult objectForKey:@"farm"];
    NSString *title = [[requestResult objectForKey:@"title"] objectForKey:@"_text"];
    
    NSLog(@"title : %@", title);
    
    PhotoRecord *photoRecord = [[PhotoRecord alloc] init];
    photoRecord.title = title;
    photoRecord.photoID = [NSString stringWithString:photoID];
    photoRecord.photoSecret = [NSString stringWithString:secret];
    photoRecord.photoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",
                                      farm, server, photoID, secret];
    NSLog(@"Liked PhotoURLString %@", photoRecord.photoURLString);
    [self.uploadPhotoList addObject:photoRecord];
    
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
}




@end
