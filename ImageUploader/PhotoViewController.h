//
//  ViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 13. 10. 22..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoViewController;
@class ImageScrollView;


@protocol PhotoViewControllerDelegate <NSObject>
- (void)photoViewControllerDidCancel:(PhotoViewController *)controller;
- (void)photoViewControllerDidSave:(PhotoViewController *)controller;
@end

@interface PhotoViewController : UIViewController
{
    ImageScrollView *_imageView;
    UIImage *_image;
    NSString *_imageURLString;
}

@property(nonatomic, strong) IBOutlet ImageScrollView *imageView;
@property(nonatomic, strong) UIImage *image;
@property(nonatomic, strong) NSString *imageURLString;

@property (nonatomic, weak) id <PhotoViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
