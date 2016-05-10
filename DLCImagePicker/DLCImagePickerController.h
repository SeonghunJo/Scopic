//
//  DLCImagePickerController.h
//  DLCImagePickerController
//
//  Created by Dmitri Cherniak on 8/14/12.
//  Copyright (c) 2012 Dmitri Cherniak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUImageView.h"
#import "DLCBlurOverlayView.h"

@class DLCImagePickerController;

@protocol DLCImagePickerDelegate <NSObject>
@optional
- (void)imagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void)imagePickerControllerDidCancel:(DLCImagePickerController *)picker;
@end

@interface DLCImagePickerController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> 

@property (nonatomic, strong) IBOutlet GPUImageView *imageView;
@property (nonatomic, strong) id <DLCImagePickerDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIButton *photoCaptureButton;
@property (nonatomic, strong) IBOutlet UIButton *cancelButton;

@property (nonatomic, strong) IBOutlet UIButton *cameraToggleButton;
@property (nonatomic, strong) IBOutlet UIButton *blurToggleButton;
//@property (nonatomic, strong) IBOutlet UIButton *filtersToggleButton;
//@property (nonatomic, strong) IBOutlet UIButton *libraryToggleButton;
@property (nonatomic, strong) IBOutlet UIButton *flashToggleButton;
@property (nonatomic, strong) IBOutlet UIButton *retakeButton;


@property (nonatomic, strong) IBOutlet UIScrollView *filterScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *filtersBackgroundImageView;
@property (nonatomic, strong) IBOutlet UIView *photoBar;
@property (nonatomic, strong) IBOutlet UIView *topBar;
// end of week
@property (nonatomic, strong) DLCBlurOverlayView *blurOverlayView;
@property (nonatomic, strong) UIImageView *focusView;

@property (nonatomic, assign) CGFloat outputJPEGQuality;
@property (nonatomic, assign) CGSize requestedImageSize;

@end
