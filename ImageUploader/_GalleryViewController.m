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

- (void)viewWillAppear:(BOOL)animated
{
    self.viewDeckController.leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
}

- (IBAction)showLeftView:(id)sender
{
    NSLog(@"showLeftView %@", self.viewDeckController);
    [self.viewDeckController toggleLeftViewAnimated:YES];
}


/*
 bbox (선택적)
 A comma-delimited list of 4 values defining the Bounding Box of the area that will be searched.
 
 The 4 values represent the bottom-left corner of the box and the top-right corner, minimum_longitude, minimum_latitude, maximum_longitude, maximum_latitude.
 
 Longitude has a range of -180 to 180 , latitude of -90 to 90. Defaults to -180, -90, 180, 90 if not specified.
 
 Unlike standard photo queries, geo (or bounding box) queries will only return 250 results per page.
 
 Geo queries require some sort of limiting agent in order to prevent the database from crying. This is basically like the check against "parameterless searches" for queries without a geo component.
 
 A tag, for instance, is considered a limiting agent as are user defined min_date_taken and min_date_upload parameters — If no limiting factor is passed we return only photos added in the last 12 hours (though we may extend the limit in the future).
 
 accuracy (필수/선택적)
 Recorded accuracy level of the photos to be updated. World level is 1, Country is ~3, Region ~6, City ~11, Street ~16. Current range is 1-16. Defaults to 16 if not specified.

 radius (선택적)
 A valid radius used for geo queries, greater than zero and less than 20 miles (or 32 kilometers), for use with point-based geo queries. The default value is 5 (km).
 radius_units (선택적)
 The unit of measure when doing radial geo queries. Valid options are "mi" (miles) and "km" (kilometers). The default is "km".
 */


- (IBAction)getPhotoWithLocation:(id)sender
{
    //flickr.places.findByLatLon
    //flickr.photos.geo.photosForLocation
    //flickr.photos.geo.batchCorrectLocation
    //flickr.photos.search
    NSString *flickrAPI = @"flickr.photos.search";
    NSString *APIKey = [NSString stringWithString:[flickrManager getAPIKey]];
    CLLocation *location = [locationManager getLocation];
    
    [locationManager stopUpdateLocation];
    
    int latitude, longitude;
    
    latitude = (int)location.coordinate.latitude;
    longitude = (int)location.coordinate.longitude;
    
    NSLog(@"%@, %d, %d", APIKey, latitude, longitude);
    
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:APIKey, @"api_key", [NSString stringWithFormat:@"%d", latitude], @"lat", [NSString stringWithFormat:@"%d", longitude], @"lon", @"11", @"accuracy", nil];
    
    [flickrRequest callAPIMethodWithPOST:flickrAPI arguments:arguments];

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
    
    flickrManager = [FlickrManager sharedInstance];
    locationManager = [LocationManager sharedInstance];
    
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[flickrManager getFlickrContext]];
    flickrRequest.delegate = self;
    flickrRequest.requestTimeoutInterval = 60.0;

    //[flickrRequest callAPIMethodWithGET:@"flickr.test.login" arguments:nil];
    
    [locationManager startUpdateLocation];
    NSLog(@"%@, %@", flickrManager, locationManager);
}


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
    /*
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
     */
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	/*
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
     */
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
