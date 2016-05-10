//
//  IntroViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 11. 29..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "IntroViewController.h"
#import "IIViewDeckController.h"


#import "FUIAlertView.h"
#import "UIFont+FlatUI.h"
#import "UIColor+FlatUI.h"

@interface IntroViewController () <FUIAlertViewDelegate>

@end

@implementation IntroViewController
@synthesize emailTextField, passwordTextField, loginButton, joinButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.viewDeckController.leftController = nil;

    [self.navigationController setNavigationBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    /*
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"login.png"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
   
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]];
    
    emailTextField.layer.cornerRadius = 1.0f;
    passwordTextField.layer.cornerRadius = 1.0f;
    loginButton.layer.cornerRadius = 1.0f;
    joinButton.layer.cornerRadius = 1.0f;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
#warning TODO : To fix it soon
    [UserManager sharedInstance].userName = @"TeamCMYK@Yahoo.com";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)backgroundTouched:(id)sender
{
    /*
    FUIAlertView *alertView = [[FUIAlertView alloc] initWithTitle:@"Hello!" message:@"Welcome to Scopic!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    alertView.titleLabel.textColor = [UIColor cloudsColor];
    //alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    alertView.messageLabel.textColor = [UIColor cloudsColor];
    //alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    alertView.defaultButtonColor = [UIColor cloudsColor];
    alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    //alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [alertView show];
     */
    NSLog(@"background Touched");
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
