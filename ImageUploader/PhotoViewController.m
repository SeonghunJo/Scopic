//
//  ViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 13. 10. 22..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "PhotoViewController.h"

NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";

@interface PhotoViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;

@end

@implementation PhotoViewController

@synthesize flickrRequest;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unavailable Camera Device" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];

        //NSMutableArray *toolbarItems = [self.toolBar.items mutableCopy];
        //[toolbarItems removeObjectAtIndex:2];
        //[self.toolBar setItems:toolbarItems animated:NO];
    }
    
    /*
     d1b46134961538a691cc649e63476d0d
     비밀(shared secret): b44292a995535ad3
*/
    flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:@"d1b46134961538a691cc649e63476d0d" sharedSecret:@"b44292a995535ad3"];
    [flickrContext setOAuthToken:@"72157637498723594-aea58e39252893a2"];
    [flickrContext setOAuthTokenSecret:@"4787600430c4fb3e"];
    
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:flickrContext];
    flickrRequest.delegate = self;
    flickrRequest.requestTimeoutInterval = 60.0;
    
    [flickrRequest callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.viewDeckController.leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
}

- (IBAction)showLeftView:(id)sender
{
    NSLog(@"showLeftView %@", self.viewDeckController);
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (IBAction)showImagePickerForCamera:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender
{
    [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)uploadButtonTouched:(id)sender;
{
    [self performSelector:@selector(_startUpload:) withObject:self.imageView.image afterDelay:0.0];
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    /*
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    */
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        /*
         The user wants to use the camera interface. Set up our custom overlay view for the camera.
         */
        //imagePickerController.showsCameraControls = NO;
        
        /*
         Load the overlay view from the OverlayView nib file. Self is the File's Owner for the nib file, so the overlayView outlet is set to the main view in the nib. Pass that view to the image picker controller to use as its overlay view, and set self's reference to the view to nil.
         */
        /*
        [[NSBundle mainBundle] loadNibNamed:@"OverlayView" owner:self options:nil];
        self.overlayView.frame = imagePickerController.cameraOverlayView.frame;
        imagePickerController.cameraOverlayView = self.overlayView;
        self.overlayView = nil;
         */
    }
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}


- (void)_startUpload:(UIImage *)image
{
    NSLog(@"Start Upload");
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
    NSLog(@"Flickr %@, %@", flickrContext.OAuthToken, flickrContext.OAuthTokenSecret);
    
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:@"CMYK" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	//[UIApplication sharedApplication].idleTimerDisabled = YES;
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"didFinishPickingMediaWithInfo");
    NSString *mediaType = [info valueForKey:UIImagePickerControllerMediaType];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *metadata = [info valueForKey:UIImagePickerControllerMediaMetadata];
    
    NSLog(@"%@", mediaType);
    NSLog(@"%@", [metadata description]);

    [self.imageView setImage:nil];
    [self.imageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark OFFlickrAPIRequest delegate methods

// 

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    NSLog(@"didObtainOAuthRequestToken %@, %@", inRequestToken, inSecret);
    // these two lines are important
    flickrContext.OAuthToken = inRequestToken;
    flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
	if (inRequest.sessionInfo == kUploadImageStep) {
		//snapPictureDescriptionLabel.text = @"Setting properties...";
        
        
        NSLog(@"%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        
        self.flickrRequest.sessionInfo = kSetImagePropertiesStep;
        [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"ImageUploader", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
		//[self updateUserInterface:nil];
		//snapPictureDescriptionLabel.text = @"Done";
        
        
        self.navigationItem.title = @"CMYK";
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == kUploadImageStep) {
		//[self updateUserInterface:nil];
		//snapPictureDescriptionLabel.text = @"Failed";
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        
		[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
        
	}
	else {
		[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
	}
    
    self.navigationItem.title = @"CMYK";
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
	if (inSentBytes == inTotalBytes) {
		//snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
        self.navigationItem.title = @"Waiting for Flickr...";
	}
	else {
        self.navigationItem.title = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
		//snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}

#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
