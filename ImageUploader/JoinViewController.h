//
//  JoinViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 11. 29..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "URLDownload.h"
#import "OFXMLMapper.h"

@interface JoinViewController : UIViewController <UITextFieldDelegate>
{
    NSOperationQueue *joinOperation;
    UIAlertView *joinAlertView;
}

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *joinButton;

@end
