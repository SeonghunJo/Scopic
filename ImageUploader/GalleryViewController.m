//
//  GalleryViewController.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 5..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "GalleryViewController.h"
#import "ViewDeckViewController.h"

#import "PhotoRecord.h"
#import "PhotoDownloader.h"

#import "PhotoViewController.h"
#import "DLCImagePickerController.h"

#ifndef _CUSTOM_UITABLEVIEWCELL_FORMS_TAG_IDS_
#define _CUSTOM_UITABLEVIEWCELL_FORMS_TAG_IDS_
/*
#define kThumbnailTag 100
#define kTitleTag 101
#define kLocationBackgroundTag 102
#define kLocationTextTag 105
#define kLikeButtonTag 102
#define kSaveButtonTag 103
*/
typedef enum
{
    kThumbnailImageViewTag = 100,
    kTitleTextLabelTag,
    kLocationBackgroundLabelTag,
    kLocationTextLabelTag,
    kLikeButtonTag,
    kSaveButtonTag,
    
} kCustomTableViewCellTagID;

#endif
@interface GalleryViewController ()<UIScrollViewDelegate, PhotoViewControllerDelegate, DLCImagePickerDelegate>
// the set of IconDownloader objects for each app
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end

@implementation GalleryViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.viewDeckController.leftController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftViewController"];
    
    self.viewDeckController.leftSize = 44.0f + 22.0f;
   
    [[LocationManager sharedInstance] startUpdateLocation];
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

- (void)getPhotoWithKeyword:(NSString *)keyword
{
    galleryType = 4;
    searchKeyword = keyword;
    [flickrRequest cancel];
    self.photoList = nil;
    [self.tableView reloadData];

    NSLog(@"GetPhotoWithKeyword : %@", keyword);
    //[refreshControl beginRefreshing];
    [photoLoadAlertView show];
    
    NSString *flickrAPI = @"flickr.photos.search";
    NSString *APIKey = [NSString stringWithString:[[FlickrManager sharedInstance] getAPIKey]];
    CLLocation *location = [locationManager getLocation];
    
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:APIKey, @"api_key", keyword, @"text", @"50", @"per_page", nil];
    
    //, [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"lon", @"16", @"accuracy", @"5", @"radius", @"km", @"radius_units", nil];
    
    NSLog(@"%@", arguments);
    
    [flickrRequest callAPIMethodWithPOST:flickrAPI arguments:arguments];
}

- (void)getPhotoWithLocation
{
    //flickr.places.findByLatLon
    //flickr.photos.geo.photosForLocation
    //flickr.photos.geo.batchCorrectLocation
    //flickr.photos.search
    galleryType = 0;
    
    [flickrRequest cancel];
    self.photoList = nil;
    [self.tableView reloadData];
    
    [refreshControl beginRefreshing];
    [photoLoadAlertView show];

    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        NSString *flickrAPI = @"flickr.photos.search";
    NSString *APIKey = [NSString stringWithString:[[FlickrManager sharedInstance] getAPIKey]];
    CLLocation *location = [locationManager getLocation];
 
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:APIKey, @"api_key", [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"lon", @"16", @"accuracy", @"1", @"radius", @"km", @"radius_units", nil];
    
    NSLog(@"%@", arguments);
    
    [flickrRequest callAPIMethodWithPOST:flickrAPI arguments:arguments];
    
}

- (void)getPhotoWithUploaded
{
    
    galleryType = 1;
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LIKE" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    
    [alert show];
     */
    [flickrRequest cancel];
    self.photoList = nil;
    self.photoList = [UserManager sharedInstance].uploadPhotoList;
    
    NSLog(@"%@", self.photoList);
    
    [self.tableView reloadData];
    
    //[refreshControl beginRefreshing];
    //[self.tableView scrollRectToVisible:CGRectMake(0, -44, 1, 1) animated:YES];

}

- (void)getPhotoWithLike
{
    
    galleryType = 2;
    
    [flickrRequest cancel];
    self.photoList = nil;
    self.photoList = [UserManager sharedInstance].likePhotoList;
    [self.tableView reloadData];
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    /*4
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"LIKE" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
    
    [alert show];
     */
    /*
    [flickrRequest cancel];
    self.photoList = nil;
    [self.tableView reloadData];
    
    NSString *flickrAPI = @"flickr.photos.search";
    NSString *APIKey = [NSString stringWithString:[[FlickrManager sharedInstance] getAPIKey]];
    CLLocation *location = [locationManager getLocation];
    
    NSDictionary *arguments = [NSDictionary dictionaryWithObjectsAndKeys:APIKey, @"api_key", [NSString stringWithFormat:@"%f", location.coordinate.latitude], @"lat", [NSString stringWithFormat:@"%f", location.coordinate.longitude], @"lon", @"16", @"accuracy", @"1", @"radius", @"km", @"radius_units", nil];
    
    NSLog(@"%@", arguments);
    
    [flickrRequest callAPIMethodWithPOST:flickrAPI arguments:arguments];
     */
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 네비게이션바에 배경 이미지 추가.
    UIImage *image = [UIImage imageNamed:@"logo.png"];
    UIImageView *naviBarImageView = [[UIImageView alloc] initWithImage:image];
    
    naviBarImageView.frame = CGRectMake((320 - image.size.width) / 2, (44 - image.size.height) / 2,
                                        image.size.width, image.size.height);
    [self.navigationController.navigationBar addSubview:naviBarImageView];
    
    locationManager = [LocationManager sharedInstance];
    
    flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[[FlickrManager sharedInstance] getFlickrContext]];
    flickrRequest.delegate = self;
    flickrRequest.requestTimeoutInterval = 60.0;
    
    self.photoList = [[NSMutableArray alloc] init];
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
    /* 타이틀 보이기 및 배경색 설정 */
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:7/255.0 green:107/255.0 blue:182/255.0 alpha:1.0]];
    
    [locationManager startUpdateLocation];
    
    /* Add Refresh Control */
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    
    //refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"사진 목록을 가져오는 중입니다"];
    self.refreshControl = refreshControl;
    /* End of refresh Control */
    
    //self.view.backgroundColor = [UIColor darkGrayColor];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
    
    
    saveAlertView = [[UIAlertView alloc] initWithTitle:@"SCOPIC" message:@"저장할까요?" delegate:self cancelButtonTitle:@"아니요" otherButtonTitles:@"네", nil];
    saveIndex = 0;
    
    
    user = [UserManager sharedInstance];
    savedPhotoList = [[NSMutableArray alloc] init];
    
    //1136 * 640 -> 11  -> 568 * 320
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator setFrame:CGRectMake((320-activityIndicator.frame.size.width)/2, (568-activityIndicator.frame.size.height)/2, activityIndicator.frame.size.width, activityIndicator.frame.size.height)];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView.backgroundView addSubview: activityIndicator];
    [activityIndicator startAnimating];
    
    photoLoadAlertView = [[UIAlertView alloc] initWithTitle:@"SCOPIC" message:@"사진을 가져오고 있습니다." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [self getPhotoWithLocation];
    
    
    NSLog(@"%@, %@", flickrManager, locationManager);
}

#pragma mark - UIRefreshControl ActionListener

- (void)refreshView:(UIRefreshControl *)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"사진 목록을 가져오는 중입니다"];
    
    switch (galleryType) {
        case 0:
            [self getPhotoWithLocation];
            break;
        case 1:
            [self getPhotoWithLike];
            break;
        case 2:
            [self getPhotoWithUploaded];
            break;
        case 3:
            [self getPhotoWithKeyword:searchKeyword];
            break;
        default:
            [self getPhotoWithLocation];
            break;
    }
    
}

//http://farm{farm-id}.staticflickr.com/{server-id}/{photo_id}_{secret}.jpg

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    //NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    //NSLog(@"%@ %@", inRequest.sessionInfo, inResponseDictionary);
    //NSLog(@"%@", [inResponseDictionary valueForKey:@"photos"]);
    
    NSDictionary *photos = [inResponseDictionary valueForKey:@"photos"];
    NSArray *photoArray = [photos valueForKey:@"photo"];
    
    NSMutableArray *newDataArray = [[NSMutableArray alloc] init];
    //NSLog(@"%@", [photos valueForKey:@"photo"]);
    for (NSDictionary *unit in photoArray) {
        NSString *photoid = [unit valueForKey:@"id"];
        NSString *secret = [unit valueForKey:@"secret"];
        NSString *server = [unit valueForKey:@"server"];
        NSString *farm = [unit valueForKey:@"farm"];
        NSString *title = [unit valueForKey:@"title"];
        
        PhotoRecord *unitPhotoRecord = [[PhotoRecord alloc] init];
        unitPhotoRecord.title = title;
        unitPhotoRecord.photoID = [NSString stringWithString:photoid];
        unitPhotoRecord.photoSecret = [NSString stringWithString:secret];
        unitPhotoRecord.photoURLString = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg",
                                          farm, server, photoid, secret];
        NSLog(@"photoURLString %@", unitPhotoRecord.photoURLString);
        [newDataArray addObject:unitPhotoRecord];
    }
    
    self.photoList = newDataArray;
    [self.tableView reloadData];
    [refreshControl endRefreshing];
    [photoLoadAlertView dismissWithClickedButtonIndex:0 animated:YES];
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
    
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    if([self.photoList count] == 0)
    {
        return 0;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    NSInteger count =  [self.photoList count];
    
    if (count == 0)
    {
        
    }
    
    return count;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alert : %d", buttonIndex);
    
    if([alertView isEqual:saveAlertView])
    {
        if(buttonIndex == 1)
        {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            PhotoRecord *record = [self.photoList objectAtIndex:saveIndex];
        
            [library writeImageDataToSavedPhotosAlbum:UIImageJPEGRepresentation(record.photo, 1.0) metadata:nil completionBlock:^(NSURL *assetURL, NSError *error)
            {
                if (error) {
                 NSLog(@"ERROR: the image failed to be written");
                }
                else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
                    [savedPhotoList addObject:record];
                     [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:saveIndex inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
                }
            }];
        }
    }
}

- (void)saveToGalleryButtonTouched:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"SaveToGalleryButtonTouched : %d", button.tag);
    
    
    PhotoRecord *record = [self.photoList objectAtIndex:button.tag];
    
    if (record.photo != nil)
    {
        saveIndex = button.tag;
        [saveAlertView show];
    }
}

- (void)likeButtonTouched:(id)sender
{
    UIButton *button = (UIButton *)sender;
    NSLog(@"likeButtonTouched : %d", button.tag);
    
    /*
    for (UIView *view in [button subviews])
    {
        [view removeFromSuperview];
    }
     */
    //[button setTitleColor:[UIColor colorWithRed:7/255.0 green:107/255.0 blue:182/255.0 alpha:1.0] forState:UIControlStateNormal];
    //[button.titleLabel setTextColor:[UIColor colorWithRed:7/255.0 green:107/255.0 blue:182/255.0 alpha:1.0]];
    
    PhotoRecord *record = [self.photoList objectAtIndex:button.tag];
    
    if(![self findPhotoRecordByPhotoID:record.photoID inPhotoList:user.likePhotoList])
    {
        [user.likePhotoList addObject:record];
    }
    else
    {
        [user.likePhotoList removeObject:record];
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:button.tag inSection:0], nil] withRowAnimation:UITableViewRowAnimationFade];
    

    // LIKE 버튼을 누르면 해당 PhotoRecord정보를 likeList array에 넣는다.
    // LIKE 버튼을 다시 누르면 해당 PhotoRecord정보를 likeList에서 찾아 뺀다.
    
    
    // 업로드시에는 똑같은 작업을 업로드 배열에서 한다.
}

- (BOOL)findPhotoRecordByPhotoID:(NSString *)photoID inPhotoList:(NSMutableArray *)photoList;
{
    for (PhotoRecord *photo in photoList) {
        if([photo.photoID isEqualToString:photoID])
        {
            return true;
        }
    }
    return false;
}


//http://farm{farm-id}.staticflickr.com/{server-id}/{photo_id}_{secret}.jpg
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath : %d", indexPath.row);
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSLog(@"Cell Frame = %f %f", cell.frame.size.width, cell.frame.size.height);
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    // add a placeholder cell while waiting on table data
    NSUInteger nodeCount = [self.photoList count];

    if (nodeCount > 0)
	{
        // Set up the cell...
        PhotoRecord *photoRecord = [self.photoList objectAtIndex:indexPath.row];
        UIImageView *photoView = (UIImageView *)[cell viewWithTag:kThumbnailImageViewTag];
        UILabel *title = (UILabel *)[cell viewWithTag:kTitleTextLabelTag];
        UILabel *locationLabel = (UILabel *)[cell viewWithTag:kLocationTextLabelTag];
        UILabel *locationBackgrondLabel = (UILabel *)[cell viewWithTag:kLocationBackgroundLabelTag];
        
        UIButton *guideSaveButton = (UIButton *)[cell viewWithTag:kSaveButtonTag];
        UIButton *guideLikeButton = (UIButton *)[cell viewWithTag:kLikeButtonTag];
        
        UIButton *saveButton = [[UIButton alloc] initWithFrame:guideSaveButton.frame];
        UIButton *likeButton = [[UIButton alloc] initWithFrame:guideLikeButton.frame];
        
        guideSaveButton.hidden = YES;
        guideLikeButton.hidden = YES;
        
        [saveButton setTitle:@"      갤러리에 추가" forState:UIControlStateNormal];
        
        [saveButton setTag:indexPath.row];
        [saveButton setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
        [saveButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [saveButton.titleLabel setTextColor:[UIColor darkGrayColor]];
        //
        if([self findPhotoRecordByPhotoID:photoRecord.photoID inPhotoList:savedPhotoList])
        {
            [saveButton setTitleColor:[UIColor colorWithRed:7/255.0 green:107/255.0 blue:182/255.0 alpha:1.0] forState:UIControlStateNormal];
            UIImageView *saveButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gallery-blue"]];
            [saveButtonImageView setFrame:CGRectMake(15, 5, 28, 28)];
            [saveButton addSubview:saveButtonImageView];

        }
        else
        {
            [saveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            UIImageView *saveButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gallery-grey"]];
            [saveButtonImageView setFrame:CGRectMake(15, 5, 28, 28)];
            [saveButton addSubview:saveButtonImageView];

        }
                //
        [saveButton addTarget:self action:@selector(saveToGalleryButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:saveButton];
        
        
        [likeButton setTitle:@"     좋아요+1" forState:UIControlStateNormal];
        if([self findPhotoRecordByPhotoID:photoRecord.photoID inPhotoList:[user likePhotoList]])
        {
            [likeButton setTitleColor:[UIColor colorWithRed:7/255.0 green:107/255.0 blue:182/255.0 alpha:1.0] forState:UIControlStateNormal];
            UIImageView *likeButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like-blue"]];
            [likeButtonImageView setFrame:CGRectMake(25, 5, 28, 28)];
            [likeButton addSubview:likeButtonImageView];
        }
        else
        {
            [likeButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            UIImageView *likeButtonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"like-grey"]];
            [likeButtonImageView setFrame:CGRectMake(25, 5, 28, 28)];
            [likeButton addSubview:likeButtonImageView];
            
            [likeButton addTarget:self action:@selector(likeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [likeButton setTag:indexPath.row];
        [likeButton setBackgroundColor:[UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0]];
        [likeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
        [likeButton addTarget:self action:@selector(likeButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:likeButton];

        
        title.text = [NSString stringWithString:photoRecord.title];
        
        // Only load cached images; defer new downloads until scrolling ends
        
        if (!photoRecord.photo)
        {
            if (self.tableView.dragging == NO && self.tableView.decelerating == NO)
            {
                [self startIconDownload:photoRecord forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
            //cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
            photoView.image = nil;
            locationBackgrondLabel.alpha = 0;
            locationLabel.text = @"";
            
            int count = 0;
            
            for(int i=indexPath.row+1; i<[self.photoList count] && count<5; i++, count++)
            {
                PhotoRecord *photoRecord = [self.photoList objectAtIndex:i];
                NSIndexPath *nowIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self startIconDownload:photoRecord forIndexPath:nowIndexPath];
            }
        }
        else
        {
            photoView.image = photoRecord.thumbnail;
            
            if(photoRecord.locationInfo != nil)
            {
                NSString *country = [[photoRecord.locationInfo objectForKey:@"country"] objectForKey:@"_text"];
                NSString *city = [[photoRecord.locationInfo objectForKey:@"county"] objectForKey:@"_text"];
                NSString *locality = [[photoRecord.locationInfo objectForKey:@"locality"] objectForKey:@"_text"];
                NSString *neighbourhood = [[photoRecord.locationInfo objectForKey:@"neighbourhood"] objectForKey:@"_text"];
                [locationLabel setText:[NSString stringWithFormat:@"%@, %@, %@, %@", country, city, locality, neighbourhood]];
                //locationBackgrondLabel.alpha = 0.2;
            }
            else
            {
            [locationLabel setText:@"위치정보가 없는 사진입니다."];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath : %d", [indexPath row]);

    //self.navigationController presentViewController: animated:<#(BOOL)#> completion:<#^(void)completion#>
    //self performSegueWithIdentifier:<#(NSString *)#> sender:<#(id)#>
    //self prepareForSegue:(UIStoryboardSegue *) sender:<#(id)#>
    //[self.navigationController pushViewController:<#(UIViewController *)#> animated:<#(BOOL)#>]
    //[self performSegueWithIdentifier:@"TakePhotoSegue" sender:self];
    //[self presentViewController:photoViewer animated:YES completion:nil];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSLog(@"shouldPerformSegue %@ %@", identifier, sender);
    
    if([identifier isEqualToString:@"ViewDetailSegue"])
    {
        PhotoRecord *nowRecord = [self.photoList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        // 다운로드가 덜 된 사진을 터치했을때 화면 전환을 방지한다.
        if(nowRecord.photo == nil)
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"%@", segue);
    
    if ([[segue identifier] isEqualToString:@"ViewDetailSegue"]) {
        NSLog(@"ViewDetailSegue");
        PhotoRecord *nowRecord = [self.photoList objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
        PhotoViewController *photoViewer = [segue destinationViewController];
        photoViewer.delegate = self;
        photoViewer.image = nowRecord.photo;
        photoViewer.imageURLString = nowRecord.photoURLString;
    }
    
}

- (void)photoViewControllerDidSave:(PhotoViewController *)controller
{
    NSLog(@"dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 435;  // ImageView Height + Photo Title Height + Buttons Height
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


/*
 
 CGFloat widthScale = 320.0f/image.size.width; 640 160
 CGFloat heightScale = 320.0f/image.size.height; 960 320
 CGFloat scale = MIN(widthScale, heightScale);
 
 self.photoRecord.thumbnail = [UIImage imageWithData:self.activeDownload scale:scale];
 */

- (CGFloat)getScaleForMaxFitMode:(CGSize)targetSize withContentSize:(CGSize)contentSize;
{
    // calculate min/max zoomscale
    CGFloat xScale = targetSize.width / contentSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = targetSize.height / contentSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully
    
    return minScale;
}

- (CGFloat)getScaleForMinFitMode:(CGSize)targetSize withContentSize:(CGSize)contentSize;
{
    // calculate min/max zoomscale
    CGFloat xScale = targetSize.width / contentSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = targetSize.height / contentSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat maxScale = MAX(xScale, yScale);                 // use minimum of these to allow the image to become fully
    
    return maxScale;
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(PhotoRecord *)photoRecord forIndexPath:(NSIndexPath *)indexPath
{
    PhotoDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    // SHJO ADDED
    if (iconDownloader == nil && photoRecord.photo == nil)
    {
        iconDownloader = [[PhotoDownloader alloc] init];
        iconDownloader.photoRecord = photoRecord;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            UIImageView *photoView = (UIImageView *)[cell viewWithTag:kThumbnailImageViewTag];
            UILabel *locationLabel = (UILabel *)[cell viewWithTag:kLocationTextLabelTag];
            UILabel *locationBackgrondLabel = (UILabel *)[cell viewWithTag:kLocationBackgroundLabelTag];
            
            photoView.alpha = 0.0;
            photoView.image = photoRecord.thumbnail;
            
            if(photoRecord.locationInfo != nil)
            {
                NSString *country = [[photoRecord.locationInfo objectForKey:@"country"] objectForKey:@"_text"];
                NSString *city = [[photoRecord.locationInfo objectForKey:@"county"] objectForKey:@"_text"];
                NSString *locality = [[photoRecord.locationInfo objectForKey:@"locality"] objectForKey:@"_text"];
                NSString *neighbourhood = [[photoRecord.locationInfo objectForKey:@"neighbourhood"] objectForKey:@"_text"];
                [locationLabel setText:[NSString stringWithFormat:@"%@, %@, %@, %@", country, city, locality, neighbourhood]];
                //locationBackgrondLabel.alpha = 0.2;
            }
            else{
               
                [locationLabel setText:@"위치정보가 없는 사진입니다."];

            }
            
            //CGFloat scale = [self getScaleForMinFitMode:photoView.frame.size withContentSize:photoRecord.photo.size];
            [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{photoView.alpha = 1.0;} completion:nil];
            //[photoView setFrame:CGRectMake(0, 0, photoRecord.thumbnail.size.width, photoRecord.thumbnail.size.height)];
            //[photoView setImage:[UIImage imageWithCGImage:photoRecord.photo.CGImage scale:scale orientation:UIImageOrientationUp]];
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            
            [UIView commitAnimations];
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
            // 다운로드가 완료된 셀을 다시 그려준다.
            //[self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }];
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        
        [iconDownloader startDownload];
        /*
        int count = 0;
        
        for(int i=indexPath.row+1; i<[self.photoList count] && count<5; i++, count++)
        {
            PhotoRecord *photoRecord = [self.photoList objectAtIndex:i];
            NSIndexPath *nowIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self startIconDownload:photoRecord forIndexPath:nowIndexPath];
        }
         */
    }
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if ([self.photoList count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSLog(@"indexPath : %@", indexPath);
            PhotoRecord *photoRecord = [self.photoList objectAtIndex:indexPath.row];
            
            if (!photoRecord.photo)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:photoRecord forIndexPath:indexPath];
            }
        }
        
        NSIndexPath *firstIndexPath = [visiblePaths firstObject];
        NSIndexPath *lastIndexPath = [visiblePaths lastObject];
        
        NSLog(@"first %d, last %d", firstIndexPath.row, lastIndexPath.row);
        
        // 보이는 셀 그룹의 위쪽과 아래쪽의 셀들에서도 동일하게 다운로드가 시작될 필요가 있다(성능 개선)
        
        /*
        // 보이는 셀 그룹의 위쪽 셀들을 다운로드 한다. (10개 단위로)
        if (lastIndexPath.row > 0)
        {
            int count = 0;
            
            for(int i=lastIndexPath.row-1; i>0 && count<20; i--, count++)
            {
                PhotoRecord *photoRecord = [self.photoList objectAtIndex:i];
                NSIndexPath *nowIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self startIconDownload:photoRecord forIndexPath:nowIndexPath];
            }
        }

        // 보이는 셀 그룹의 아래쪽 셀들을 다운로드 한다. (10개 단위로)
        if (lastIndexPath.row < [self.photoList count])
        {
            int count = 0;
            
            for(int i=lastIndexPath.row+1; i<[self.photoList count] && count<20; i++, count++)
            {
                PhotoRecord *photoRecord = [self.photoList objectAtIndex:i];
                NSIndexPath *nowIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self startIconDownload:photoRecord forIndexPath:nowIndexPath];
            }
        }*/
        //
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%s", __FUNCTION__);
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self loadImagesForOnscreenRows];
}

@end
