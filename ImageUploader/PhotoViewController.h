//
//  ViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 13. 10. 22..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

#import "IIViewDeckController.h"

@interface PhotoViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDelegate, OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
    OFFlickrAPIContext *flickrContext;
}


@end
