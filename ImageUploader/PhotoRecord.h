//
//  PhotoRecord.h
//  ImageUploader
//
//  Created by 조 성훈 on 2013. 12. 8..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

/*
 서버로부터 받은 이미지 파일 하나에 대한 정보를 담고있는 클래스
 */
#import <Foundation/Foundation.h>

@interface PhotoRecord : NSObject

@property (strong, nonatomic) UIImage *photo;       // ORIGINAL IMAGE
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;

@property (strong, nonatomic) UIImage *thumbnail;   // GALLERY THUMBNAIL IMAGE

@property (strong, nonatomic) NSString *photoID;    // FLICKR PHOTO ID
@property (strong, nonatomic) NSString *photoSecret;// FLICKR PHOTO SECRET

@property (strong, nonatomic) NSString *photoURLString;
@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSDictionary *locationInfo;
/*
 Location {
 "_text" = "\n\t\t\n\t\t\n\t\t\n\t\t\n\t\t\n\t";
 accuracy = 16;
 context = 0;
 country =     {
 "_text" = "South Korea";
 "place_id" = t33qbc9TUb4om3HfTg;
 woeid = 23424868;
 };
 county =     {
 "_text" = "Anyang-Si";
 "place_id" = etdUDwRTWrilIrZqzA;
 woeid = 28289110;
 };
 latitude = "37.39118";
 locality =     {
 "_text" = "\Ub3d9\Uc548\Uad6c";
 "place_id" = bQJGMPxTWrOBsFmyyw;
 woeid = 28997203;
 };
 longitude = "126.973776";
 neighbourhood =     {
 "_text" = "\Uad00\Uc5912\Ub3d9";
 "place_id" = jNl62W1TWrKeH7fGtg;
 woeid = 28806775;
 };
 "place_id" = jNl62W1TWrKeH7fGtg;
 region =     {
 "_text" = "Kyeongki-Do";
 "place_id" = "v.vPs59TUb5h.UMa";
 woeid = 2345969;
 };
 woeid = 28806775;
 }
 */

@end
