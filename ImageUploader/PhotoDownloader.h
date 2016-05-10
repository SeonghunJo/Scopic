//
//  PhotoDownloader.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 8..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "ObjectiveFlickr.h"
#import "FlickrManager.h"

@class PhotoRecord;

@interface PhotoDownloader : NSObject <OFFlickrAPIRequestDelegate>

@property (nonatomic, copy) void (^completionHandler)(void);
@property (nonatomic, strong) PhotoRecord *photoRecord;
@property (nonatomic, strong) NSDictionary *photoInfo;
- (void)startDownload;
- (void)cancelDownload;

@end
