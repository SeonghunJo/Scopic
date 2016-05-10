//
//  GalleryViewController.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 5..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrManager.h"
#import "LocationManager.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "UserManager.h"

@interface GalleryViewController : UITableViewController <OFFlickrAPIRequestDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>
{
    FlickrManager *flickrManager;
    LocationManager *locationManager;
    
    OFFlickrAPIRequest *flickrRequest;
    UIRefreshControl *refreshControl;
    
    UIAlertView *saveAlertView;
    NSUInteger saveIndex;
    
    UserManager *user;
    NSMutableArray *savedPhotoList;
    
    UIActivityIndicatorView *activityIndicator;
    
    NSInteger galleryType;
    NSString *searchKeyword;
    
    UIAlertView *photoLoadAlertView;
}


-(void)getPhotoWithKeyword:(NSString *)keyword;
-(void)getPhotoWithLocation;
-(void)getPhotoWithLike;
-(void)getPhotoWithUploaded;

@property (nonatomic, strong) NSMutableArray *photoList;

@property (nonatomic, strong) NSMutableArray *likedPhotoList;   // Like된 PhotoRecord들을 저장
@property (nonatomic, strong) NSMutableArray *uploadedPhotoList;// Uploaded된 PhotoRecord들을 저장

@end
