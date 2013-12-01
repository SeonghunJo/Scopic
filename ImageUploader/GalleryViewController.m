//
//  GalleryViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 1..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "GalleryViewController.h"
#import "IIViewDeckController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

- (IBAction)showLeftView:(id)sender
{
    NSLog(@"showLeftView %@", self.viewDeckController);
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
