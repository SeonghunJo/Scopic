//
//  AppDelegate.h
//  ImageUploader
//
//  Created by 조 성훈 on 13. 10. 22..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

#import "IIViewDeckController.h"

@class IIViewDeckController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (retain, nonatomic) UIViewController *centerController;
@property (strong, nonatomic) UIStoryboard *storyboard;

@property (strong, nonatomic) IIViewDeckController *viewDeck;
//- (IIViewDeckController*)generateControllerStack;
@end