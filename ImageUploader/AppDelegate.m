//
//  AppDelegate.m
//  ImageUploader
//
//  Created by 조 성훈 on 13. 10. 22..
//  Copyright (c) 2013년 Seonghun Jo. All rights reserved.
//

#import "AppDelegate.h"
#import "IIWrapController.h"
#import "IISideController.h"
#import "LeftViewController.h"

#import "LocationManager.h"
#import "FlickrManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //self.storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //[self generateControllerStack];
    /* To adjust speed of open/close animations, set either of these two properties. */
    // deckController.openSlideAnimationDuration = 0.15f;
    // deckController.closeSlideAnimationDuration = 0.5f;
    LocationManager *locationManager = [LocationManager sharedInstance];
    [locationManager startUpdateLocation];
    
    /*
     // Navigation bar appearance (background and title)
     
     [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor titleColor], NSForegroundColorAttributeName, [UIFont fontWithName:@"FontNAme" size:titleSize], NSFontAttributeName, nil]];
     
     [[UINavigationBar appearance] setTintColor:[UIColor barColor]];
     
     // Navigation bar buttons appearance
     
     [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor textBarColor], NSForegroundColorAttributeName, shadowColor, NSShadowAttributeName, [UIFont fontWithName:@"FontName" size:titleSize], NSFontAttributeName, nil];
     */
    return YES;

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
