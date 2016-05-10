//
//  UserManager.h
//  Scopic
//
//  Created by 조 성훈 on 2013. 12. 19..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLDownload.h"
#import "OFXMLMapper.h"

#import "ObjectiveFlickr.h"
#import "FlickrManager.h"

#import "PhotoRecord.h"

@interface UserManager : NSObject <NSURLConnectionDelegate, OFFlickrAPIRequestDelegate>
{
    NSString *userName;

    NSMutableArray *likedPhotoList;
    NSMutableArray *uploadedPhotoList;
    
    NSOperationQueue *operationQueue;
    OFFlickrAPIRequest *flickrRequest;
}

+(UserManager *)sharedInstance;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSMutableArray *likePhotoList;
@property (strong, nonatomic) NSMutableArray *uploadPhotoList;

- (void)getUploadedPhotoInfoWithID:(NSString *)photoID;

@end
