//
//  ViewDeckViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 1..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "ViewDeckViewController.h"

@interface ViewDeckViewController ()

@end

@implementation ViewDeckViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UINavigationController *mainNavi = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    
    self = [super initWithCenterViewController:mainNavi];
    
    if (self) {
        // Add any extra init code here
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
