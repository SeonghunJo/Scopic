//
//  UploadPhotoViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 10..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrManager.h"
#import "GPUImage.h"
#import "DLCImagePickerController.h"

#import "IIViewDeckController.h"
#import "LocationManager.h"

#import "UIPlaceholderTextView.h"

#import "UserManager.h"

#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>

@interface UploadPhotoViewController : UIViewController <UINavigationControllerDelegate, DLCImagePickerDelegate, OFFlickrAPIRequestDelegate, UIAlertViewDelegate, UITextViewDelegate>
{
    OFFlickrAPIRequest *flickrRequest;
    OFFlickrAPIRequest *findByLatLonRequest;
    
    UIAlertView *uploadAlertView;
    UIAlertView *uploadResultView;
    UIProgressView *uploadProgressView;
    
    CLLocation *location;
    
    NSString *photoID;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *titleTextView;
@property (weak, nonatomic) IBOutlet UITextField *descTextField;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//@property (weak, nonatomic) IBOutlet UILabel *locationBackgroundLabel;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end
