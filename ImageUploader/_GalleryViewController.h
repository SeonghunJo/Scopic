//
//  GalleryViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 1..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlickrManager.h"
#import "LocationManager.h"

@interface GalleryViewController : UIViewController <OFFlickrAPIRequestDelegate>
{
    FlickrManager *flickrManager;
    LocationManager *locationManager;
    
    OFFlickrAPIRequest *flickrRequest;
}
@end
