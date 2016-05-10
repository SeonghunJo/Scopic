//
//  UploadPhotoViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 10..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "UploadPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";

@interface UploadPhotoViewController ()
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@end

@implementation UploadPhotoViewController

@synthesize flickrRequest;

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
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        // There is not a camera on this device, so don't show the camera button.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unavailable Camera Device" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
    }
    
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[[FlickrManager sharedInstance] getFlickrContext]];
    flickrRequest.delegate = self;
    flickrRequest.requestTimeoutInterval = 60.0;
    
    //[flickrRequest callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
    

    findByLatLonRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[[FlickrManager sharedInstance] getFlickrContext]];
    findByLatLonRequest.delegate = self;
    findByLatLonRequest.requestTimeoutInterval = 30.0;
    
    /*
    
    location = [[LocationManager sharedInstance] getLocation];
    [findByLatLonRequest callAPIMethodWithPOST:@"flickr.places.findByLatLon" arguments:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lat",
                                                                                        [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"lon", @"16", @"accuracy" ,nil]];
    */
    
    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.uploadButton setBackgroundColor:[UIColor colorWithRed:7/255.0 green:107/255.0 blue:182/255.0 alpha:1.0]];
    
    
    uploadAlertView = [[UIAlertView alloc] initWithTitle:@"SCOPIC" message:@"업로드 중입니다..." delegate:self cancelButtonTitle:@"업로드 취소" otherButtonTitles:nil];
    
    self.titleTextView.placeholder = @"사진을 설명하는 제목을 입력해주세요!";
    self.titleTextView.delegate = self;
    
    [self takePhotoWithAnimation:NO];
}

/*
- (void)keyboardWillAnimate:(NSNotification *)notification
{
    CGRect keyboardBounds;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    if([notification name] == UIKeyboardWillShowNotification)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - keyboardBounds.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else if([notification name] == UIKeyboardWillHideNotification)
    {
        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + keyboardBounds.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    }
    [UIView commitAnimations];
}
 */

- (void)keyboardWillShow:(NSNotification *) notif {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, -152, 320, 504); // 키보드 높이가 152 인듯하다.
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated
{
    uploadProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 63, 320, 3)];
    [self.navigationController.view addSubview:uploadProgressView];
    
    self.viewDeckController.leftController = nil;
    [[LocationManager sharedInstance] startUpdateLocation];
    
    location = [[LocationManager sharedInstance] getLocation];
    [findByLatLonRequest callAPIMethodWithPOST:@"flickr.places.findByLatLon" arguments:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lat",
                                                                                        [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"lon", @"16", @"accuracy" ,nil]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [uploadProgressView removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    [textField resignFirstResponder];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = CGRectMake(0, 62, 320, 504);
    [UIView commitAnimations];
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = CGRectMake(0, 62, 320, 504);
        [UIView commitAnimations];
        return NO;
    }
    
    return YES;
}

- (IBAction)backgroundTouched:(id)sender
{
    NSLog(@"background Touched");
    [self.view endEditing:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView isEqual:uploadAlertView])
    {
        if(buttonIndex == 0)
        {
            [flickrRequest cancel];
        }
        else if(buttonIndex == 1)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)uploadButtonTouched:(id)sender;
{
    [self performSelector:@selector(_startUpload:) withObject:self.imageView.image afterDelay:0.0];
    //[sender setEnabled:FALSE];
    [uploadAlertView show];
    
}

- (void)_startUpload:(UIImage *)image
{
    NSLog(@"Start Upload");
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData] suggestedFilename:@"Scopic" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	//[UIApplication sharedApplication].idleTimerDisabled = YES;
}


- (IBAction)takePhoto:(id)sender
{
    [self takePhotoWithAnimation:YES];
}

- (void)takePhotoWithAnimation:(BOOL)animated
{
    DLCImagePickerController *imagePicker = [[DLCImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    if(imagePicker == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"카메라가 초기화되지 않았습니다" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [alert show];
    }
    else
    {
        [self presentViewController:imagePicker animated:animated completion:nil];
    }
}

-(void) imagePickerControllerDidCancel:(DLCImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void) imagePickerController:(DLCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [self dismissViewControllerAnimated:YES completion:nil];

    if (info) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSDictionary *GPSDict = [self getGPSDictionaryForLocation:[[LocationManager sharedInstance] getLocation]];
        NSDictionary *metadata = [NSDictionary dictionaryWithObjectsAndKeys:GPSDict, kCGImagePropertyGPSDictionary, nil];
        UIImage *image = [UIImage imageWithData:[info objectForKey:@"data"]];
        [self.imageView setImage:image];
        
        [library writeImageDataToSavedPhotosAlbum:[info objectForKey:@"data"] metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error)
         {
             if (error) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
             }
         }];
    }
    
    
}


- (NSDictionary *)getGPSDictionaryForLocation:(CLLocation *)location {
    NSMutableDictionary *gps = [NSMutableDictionary dictionary];
    
    // GPS tag version
    [gps setObject:@"2.2.0.0" forKey:(NSString *)kCGImagePropertyGPSVersion];
    
    // Time and date must be provided as strings, not as an NSDate object
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm:ss.SSSSSS"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [formatter setDateFormat:@"yyyy:MM:dd"];
    [gps setObject:[formatter stringFromDate:location.timestamp] forKey:(NSString *)kCGImagePropertyGPSDateStamp];;
    
    // Latitude
    CGFloat latitude = location.coordinate.latitude;
    if (latitude < 0) {
        latitude = -latitude;
        [gps setObject:@"S" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    } else {
        [gps setObject:@"N" forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:latitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    
    // Longitude
    CGFloat longitude = location.coordinate.longitude;
    if (longitude < 0) {
        longitude = -longitude;
        [gps setObject:@"W" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    } else {
        [gps setObject:@"E" forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    }
    [gps setObject:[NSNumber numberWithFloat:longitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    
    // Altitude
    CGFloat altitude = location.altitude;
    if (!isnan(altitude)){
        if (altitude < 0) {
            altitude = -altitude;
            [gps setObject:@"1" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        } else {
            [gps setObject:@"0" forKey:(NSString *)kCGImagePropertyGPSAltitudeRef];
        }
        [gps setObject:[NSNumber numberWithFloat:altitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
    }
    
    // Speed, must be converted from m/s to km/h
    if (location.speed >= 0){
        [gps setObject:@"K" forKey:(NSString *)kCGImagePropertyGPSSpeedRef];
        [gps setObject:[NSNumber numberWithFloat:location.speed*3.6] forKey:(NSString *)kCGImagePropertyGPSSpeed];
    }
    
    // Heading
    if (location.course >= 0){
        [gps setObject:@"T" forKey:(NSString *)kCGImagePropertyGPSTrackRef];
        [gps setObject:[NSNumber numberWithFloat:location.course] forKey:(NSString *)kCGImagePropertyGPSTrack];
    }
    
    return gps;
}

/*
-(UIImage *)addMetaData:(UIImage *)image {
    
    NSData *jpeg = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0)];
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)jpeg, NULL);
    
    NSDictionary *metadata = [[asset_ defaultRepresentation] metadata];
    
    NSMutableDictionary *metadataAsMutable = [metadata mutableCopy];
    
    NSMutableDictionary *EXIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary];
    NSMutableDictionary *GPSDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary];
    NSMutableDictionary *TIFFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyTIFFDictionary];
    NSMutableDictionary *RAWDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyRawDictionary];
    NSMutableDictionary *JPEGDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyJFIFDictionary];
    NSMutableDictionary *GIFDictionary = [metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    if(!EXIFDictionary) {
        EXIFDictionary = [NSMutableDictionary dictionary];
    }
    
    if(!GPSDictionary) {
        GPSDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!TIFFDictionary) {
        TIFFDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!RAWDictionary) {
        RAWDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!JPEGDictionary) {
        JPEGDictionary = [NSMutableDictionary dictionary];
    }
    
    if (!GIFDictionary) {
        GIFDictionary = [NSMutableDictionary dictionary];
    }
    
    [metadataAsMutable setObject:EXIFDictionary forKey:(NSString *)kCGImagePropertyExifDictionary];
    [metadataAsMutable setObject:GPSDictionary forKey:(NSString *)kCGImagePropertyGPSDictionary];
    [metadataAsMutable setObject:TIFFDictionary forKey:(NSString *)kCGImagePropertyTIFFDictionary];
    [metadataAsMutable setObject:RAWDictionary forKey:(NSString *)kCGImagePropertyRawDictionary];
    [metadataAsMutable setObject:JPEGDictionary forKey:(NSString *)kCGImagePropertyJFIFDictionary];
    [metadataAsMutable setObject:GIFDictionary forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    CFStringRef UTI = CGImageSourceGetType(source);
    
    NSMutableData *dest_data = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)dest_data,UTI,1,NULL);
    
    //CGImageDestinationRef hello;
    
    CGImageDestinationAddImageFromSource(destination,source,0, (__bridge CFDictionaryRef) metadataAsMutable);
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success) {
    }
    
    dataToUpload_ = dest_data;
    
    CFRelease(destination);
    CFRelease(source);
    
    return image;
}
*/
 
/*
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
*/

#pragma mark OFFlickrAPIRequest delegate methods

/*
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    NSLog(@"didObtainOAuthRequestToken %@, %@", inRequestToken, inSecret);
    // these two lines are important
    flickrContext.OAuthToken = inRequestToken;
    flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    [[UIApplication sharedApplication] openURL:authURL];
}
*/

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
    if ([inRequest isEqual:flickrRequest])
    {
        if (inRequest.sessionInfo == kUploadImageStep) {
		//snapPictureDescriptionLabel.text = @"Setting properties...";
        
        
            NSLog(@"%@", inResponseDictionary);
            photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        
            self.flickrRequest.sessionInfo = kSetImagePropertiesStep;
        
        
            [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", self.titleTextView.text, @"title",[NSString     stringWithFormat:@"%@", [NSDate date]], @"description", nil]];
            //[self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", self.titleTextField.text, @"title",[NSString     stringWithFormat:@"%@", [NSDate date]], @"description", nil]];
        }
        else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
            //[self updateUserInterface:nil];
            //snapPictureDescriptionLabel.text = @"Done";
        
            [self.progressView setProgress:1.0f animated:YES];
            [UIApplication sharedApplication].idleTimerDisabled = NO;
        
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"SCOPIC" message:@"완료되었습니다." delegate:Nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
            [alertView show];
            
            [[UserManager sharedInstance] getUploadedPhotoInfoWithID:photoID];
            
            [uploadAlertView dismissWithClickedButtonIndex:0 animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        
        }
    }
    else if([inRequest isEqual:findByLatLonRequest])
    {
        NSLog(@"%@", inResponseDictionary);
        NSDictionary *places = [inResponseDictionary objectForKey:@"places"];
        NSDictionary *place = [places objectForKey:@"place"];
        NSLog(@"%@", place);
        
        for (NSDictionary *dic in place) {
            
            //name, woe_name, place_url
            NSString *currentPlaceName = [dic objectForKey:@"woe_name"];
            
            //self.locationBackgroundLabel.alpha = 0.0;
            self.locationLabel.alpha = 0.0;
            
            [self.locationLabel setText:[NSString stringWithFormat:@"%@ 근처에서", currentPlaceName]];
            [UIView animateWithDuration:0.0 delay:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{self.locationLabel.alpha = 1.0;} completion:nil];
            
            [UIView commitAnimations];
            
            if([self.titleTextView.text length] == 0)
            {
                self.titleTextView.placeholder =[NSString stringWithFormat:@"사진을 설명하는 제목을 입력해주세요! 예)%@ 근처에서", currentPlaceName];
            }
            break;
        }
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    if([inRequest isEqual:flickrRequest])
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
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
    if([inRequest isEqual:flickrRequest])
    {
        if (inSentBytes == inTotalBytes) {
            //snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
            //self.navigationItem.title = @"Waiting for Flickr...";
            uploadAlertView.message = [NSString stringWithFormat:@"사진정보를 설정하고 있습니다.", inSentBytes / 1024, inTotalBytes / 1024];
            [self.progressView setProgress:0.99 animated:YES];
        }
        else {
            //self.navigationItem.title = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
            CGFloat sentBytes, totalBytes;
            sentBytes = totalBytes = 0.0f;
            sentBytes = inSentBytes;
            totalBytes = inTotalBytes;
            
            //uploadAlertView.message = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
            NSUInteger percent = sentBytes / totalBytes * 100;
            uploadAlertView.message = [NSString stringWithFormat:@"%d%%", percent];
            [uploadProgressView setProgress:sentBytes/totalBytes animated:YES];
            [self.progressView setProgress:sentBytes/totalBytes animated:YES];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end