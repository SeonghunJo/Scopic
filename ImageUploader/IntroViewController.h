//
//  IntroViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 11. 29..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserManager.h"
#import "URLDownload.h"

@interface IntroViewController : UIViewController <UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *joinButton;

@end
