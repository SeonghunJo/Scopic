//
//  JoinViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 11. 29..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "JoinViewController.h"

@interface JoinViewController () <UIAlertViewDelegate>

@end

@implementation JoinViewController

@synthesize emailTextField, passwordTextField, confirmTextField, joinButton, cancelButton;

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
    [self.navigationController setNavigationBarHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]];
    
    self.emailTextField.layer.cornerRadius = 1.0f;
    self.passwordTextField.layer.cornerRadius = 1.0f;
    self.confirmTextField.layer.cornerRadius = 1.0f;
    self.joinButton.layer.cornerRadius = 1.0f;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    joinAlertView = [[UIAlertView alloc] initWithTitle:@"SCOPIC" message:@"가입요청중입니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    joinOperation = [[NSOperationQueue alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)backgroundTouched:(id)sender
{
    NSLog(@"background Touched");
    [self.view endEditing:YES];
}

- (void)showSimpleAlertView:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SCOPIC" message:message delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
   [alertView show];
}

- (IBAction)join:(id)sender
{
    if([self.emailTextField.text stringByTrimmingCharactersInSet:
        [NSCharacterSet whitespaceCharacterSet]].length == 0 || [self.emailTextField.text stringByTrimmingCharactersInSet:
                                                                 [NSCharacterSet whitespaceCharacterSet]].length == 0 || [self.emailTextField.text stringByTrimmingCharactersInSet:
                                                                                                                          [NSCharacterSet whitespaceCharacterSet]].length == 0 )
    {
        [self showSimpleAlertView:@"아이디와 비밀번호를 입력해주세요"];
        return;
    }
    
    if(![self.passwordTextField.text isEqualToString:self.confirmTextField.text])
    {
        [self showSimpleAlertView:@"비밀번호가 일치하지 않습니다."];
        return;
    }
    
    
    [joinAlertView show];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://acevill.iptime.org:8080/CMYK/Join?user_id=%@&password&%@", self.emailTextField.text, self.passwordTextField.text]]];
    
    URLDownload *joinRequest = [[URLDownload alloc] initWithRequest:request delegate:self selector:@selector(receiveDataDownload:data:error:)];
    
    [joinOperation addOperation:joinRequest];
    //[self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)receiveDataDownload:(URLDownload *)aDownload data:(NSData *)data error:(NSError *)error
{
    [joinAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SCOPIC" message:@"가입완료!" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];

    if (data)
    {
        NSString *content = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"urlDownload content : %@", content);
        
        NSDictionary *dataDict = [OFXMLMapper dictionaryMappedFromXMLData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        NSDictionary *rsp = [dataDict objectForKey:@"rsp"];
        NSLog(@"%@",rsp);
        NSDictionary *resultDict = [rsp objectForKey:@"result"];
        NSLog(@"%@", resultDict);
        NSString *resultString = [resultDict objectForKey:@"_text"];
        NSLog(@"%@", resultString);
        
        if(resultString)
        {
            if([resultString isEqualToString:@"0"])
            {
                [alertView setMessage:@"존재하는 아이디입니다."];
            }
            else
            {
                [alertView setDelegate:self];
            }
            
        }
        else
        {
            [alertView setMessage:@"서버 오류"];
        }
    }
    else // error
    {
        [alertView setMessage:@"서버 접속 오류"];
        NSLog(@"receiveDataDownload error: %@", error);
        

    }
    [alertView show];
}

@end
