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
    
    ShadowNavigationViewController *mainNavi = [storyboard instantiateViewControllerWithIdentifier:@"MainNavigation"];
    mainNavi.navigationBar.backgroundColor = [UIColor colorWithRed:7/255.0 green:107/255.0 blue:182/255.0 alpha:1.0];
    
    self = [super initWithCenterViewController:mainNavi];
    if (self) {
        // Add any extra init code here
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

/*
- (void)viewDeckController:(IIViewDeckController *)viewDeckController applyShadow:(CALayer *)shadowLayer withBounds:(CGRect)rect
{
    NSLog(@"shadow");
    shadowLayer.masksToBounds = NO;
    shadowLayer.shadowRadius = 10;
    shadowLayer.shadowOpacity = 1.0;
    shadowLayer.shadowColor = [[UIColor blueColor] CGColor];
    shadowLayer.shadowOffset = CGSizeMake(0.0, 3.0);
    shadowLayer.shadowPath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
