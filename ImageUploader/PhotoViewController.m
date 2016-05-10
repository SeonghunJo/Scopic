//
//  ViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 13. 10. 22..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "PhotoViewController.h"
#import "ImageScrollView.h"

@interface PhotoViewController ()

@end

@implementation PhotoViewController
@synthesize imageView = _imageView;
@synthesize image = _image;
@synthesize imageURLString = _imageURLString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"PhotoViewDidLoad");

    if(self.image != nil)
    {
        NSLog(@"photo is not nil");
        NSLog(@"%@", self.image);
        NSLog(@"%@", self.imageURLString);
        
        [self.imageView displayImage:self.image];
    }
    else
    {
        NSLog(@"photo is nil");
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"PhotoViewWillAppear");
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"PhotoViewWillDisappear");
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (IBAction)cancel:(id)sender
{
	[self.delegate photoViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
	[self.delegate photoViewControllerDidSave:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
