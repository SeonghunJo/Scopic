//
//  PhotoDownloader.m
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 8..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "PhotoDownloader.h"
#import "PhotoRecord.h"
#import <UIKit/UIKit.h>

@interface PhotoDownloader ()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@property (nonatomic, strong) OFFlickrAPIRequest *flickrRequest;
@end


@implementation PhotoDownloader

/*
 flickr.photos.getInfo // photoid, secret
 
 <?xml version="1.0" encoding="utf-8" ?>
 <rsp stat="ok">
 <photo id="8402175024" secret="1631ecfbc0" server="8212" farm="9" dateuploaded="1358772827" isfavorite="0" license="0" safety_level="0" rotation="0" originalsecret="a914faa37b" originalformat="jpg" views="34" media="photo">
 <owner nsid="8276381@N02" username="HUMAN&HEROBUM" realname="BOM HEE LEE" location="Anyang, Korea" iconserver="5267" iconfarm="6" path_alias="herobum" />
 <title>오늘 저녁은 스트레스 해소용 진수성찬(?) 버전.. +_+ with #소맥 #humandays #somac</title>
 <description />
 <visibility ispublic="1" isfriend="0" isfamily="0" />
 <dates posted="1358772827" taken="2013-01-21 21:53:47" takengranularity="0" lastupdate="1358772831" />
 <editability cancomment="1" canaddmeta="0" />
 <publiceditability cancomment="1" canaddmeta="0" />
 <usage candownload="1" canblog="1" canprint="0" canshare="1" />
 <comments>0</comments>
 <notes />
 <people haspeople="0" />
 <tags>
 <tag id="8256033-8402175024-60504812" author="8276381@N02" raw="instagram app" machine_tag="0">instagramapp</tag>
 <tag id="8256033-8402175024-1628" author="8276381@N02" raw="square" machine_tag="0">square</tag>
 <tag id="8256033-8402175024-14976" author="8276381@N02" raw="square format" machine_tag="0">squareformat</tag>
 <tag id="8256033-8402175024-34115330" author="8276381@N02" raw="iphoneography" machine_tag="0">iphoneography</tag>
 <tag id="8256033-8402175024-60643605" author="8276381@N02" raw="uploaded:by=instagram" machine_tag="1">uploaded:by=instagram</tag>
 <tag id="8256033-8402175024-60505444" author="8276381@N02" raw="X-Pro II" machine_tag="0">xproii</tag>
 <tag id="8256033-8402175024-101065774" author="8276381@N02" raw="foursquare:venue=50baa80de4b0f3072b872225" machine_tag="1">foursquare:venue=50baa80de4b0f3072b872225</tag>
 </tags>
 <location latitude="37.394411" longitude="126.98097" accuracy="16" context="0" place_id="jNl62W1TWrKeH7fGtg" woeid="28806775">
 <neighbourhood place_id="jNl62W1TWrKeH7fGtg" woeid="28806775">관양2동</neighbourhood>
 <locality place_id="bQJGMPxTWrOBsFmyyw" woeid="28997203">동안구</locality>
 <county place_id="etdUDwRTWrilIrZqzA" woeid="28289110">Anyang-Si</county>
 <region place_id="v.vPs59TUb5h.UMa" woeid="2345969">Kyeongki-Do</region>
 <country place_id="t33qbc9TUb4om3HfTg" woeid="23424868">South Korea</country>
 </location>
 <geoperms ispublic="1" iscontact="0" isfriend="0" isfamily="0" />
 <urls>
 <url type="photopage">http://www.flickr.com/photos/herobum/8402175024/</url>
 </urls>
 </photo>
 </rsp>
 */

#pragma mark

- (void)getPhotoInfo
{
    
    self.flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[[FlickrManager sharedInstance] getFlickrContext]];
    self.flickrRequest.delegate = self;
    self.flickrRequest.requestTimeoutInterval = 60.0;
    
    //[self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.getSizes" arguments:[[NSDictionary alloc] initWithObjectsAndKeys:[[FlickrManager sharedInstance] getAPIKey], @"api_key", self.photoRecord.photoID, @"photo_id", nil ]];
    
    [self.flickrRequest callAPIMethodWithPOST:@"flickr.photos.getInfo" arguments:[[NSDictionary alloc] initWithObjectsAndKeys:self.photoRecord.photoID, @"photo_id", self.photoRecord.photoSecret, @"secret", nil]];
}

- (void)startDownload
{
    self.activeDownload = [NSMutableData data];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.photoRecord.photoURLString]];
    
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    self.imageConnection = conn;
    
    [self getPhotoInfo];
}

- (void)cancelDownload
{
    [self.imageConnection cancel];
    self.imageConnection = nil;
    self.activeDownload = nil;
    
    [self.flickrRequest cancel];
    self.flickrRequest = nil;
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownload = nil;
    
    // Release the connection now that it's finished
    self.imageConnection = nil;
}

#define kAppIconSize 320

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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownload];
    
    /*
    if (image.size.width != kAppIconSize || image.size.height != kAppIconSize)
	{
        CGSize itemSize = CGSizeMake(kAppIconSize, kAppIconSize);
		UIGraphicsBeginImageContextWithOptions(itemSize, NO, 0.0f);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.photoRecord.photo = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.photoRecord.photo = image;
    }
    */
    
    self.photoRecord.photo = image;
    
    CGSize photoFrameSize = CGSizeMake(320.0f, 320.0f);
    CGFloat scale = [self getScaleForMinFitMode:photoFrameSize withContentSize:self.photoRecord.photo.size];
    CGSize newSize = CGSizeMake(self.photoRecord.photo.size.width * scale, self.photoRecord.photo.size.height * scale);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    self.photoRecord.thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    //CGFloat scale = [self getScaleForMaxFitMode:photoFrameSize withContentSize:self.photoRecord.photo.size];
    //NSLog(@"original %f %f, scale : %f -> maybe : %f %f", self.photoRecord.photo.size.width, self.photoRecord.photo.size.height, scale, self.photoRecord.photo.size.width * scale, self.photoRecord.photo.size.height * scale);
    
    self.photoRecord.height = image.size.width;
    self.photoRecord.width = image.size.width;
    //NSLog(@"scaled Size -> %f %f", self.photoRecord.thumbnail.size.width, self.photoRecord.thumbnail.size.height);
    
    
    //self.activeDownload = nil;
    
    // Release the connection now that it's finished
    //self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    //if (self.completionHandler)
    //    self.completionHandler();
    
    [self checkComplete];
}


- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    //NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    //NSLog(@"%@ %@", inRequest.sessionInfo, inResponseDictionary);
    //NSLog(@"%@", [inResponseDictionary valueForKey:@"photos"]);
    
    /*
    NSDictionary *photos = [inResponseDictionary valueForKey:@"sizes"];
    NSArray *sizeArray = [photos valueForKey:@"size"];
    
    //NSLog(@"%@", [photos valueForKey:@"photo"]);
    for (NSDictionary *unit in sizeArray) {

    }
     */
    self.photoInfo = [inResponseDictionary objectForKey:@"photo"];
    self.photoRecord.locationInfo = [self.photoInfo objectForKey:@"location"];
    
    [self checkComplete];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
}


- (void)checkComplete
{
    if(self.photoRecord.photo != nil && self.photoInfo != nil)
    {
        [self notifyComplete];
    }
}

- (void)notifyComplete
{
    self.activeDownload = nil;
    
    //Release the connection now that it's finished
    self.imageConnection = nil;
    
    // call our delegate and tell it that our icon is ready for display
    if (self.completionHandler)
        self.completionHandler();
}




@end
