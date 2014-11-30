//
//  HNAppDelegate.m
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNAppDelegate.h"
#import "HNLeftMenuViewController.h"
#import "HNGenericNewsViewController.h"
#import "HNClient.h"

typedef NS_OPTIONS(NSUInteger, SectionIdentifier) {
    sectionTypePopular = 0
};
@implementation HNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024
                                                      diskCapacity:3*1024
                                                          diskPath:@"app_cache"];
    
    // Set the shared cache to our new  instance
    [NSURLCache setSharedURLCache:cache];
    
    HNClient *client = [HNClient shareClient];
    HNSection *popularSection = [HNSection sectionForID:@(sectionTypePopular)];
    
    HNGenericNewsViewController *latestViewController = [[HNGenericNewsViewController alloc] initWithItem:popularSection];
    UINavigationController *newsContentView = [[UINavigationController alloc] initWithRootViewController:latestViewController];
    HNLeftMenuViewController *menuViewController = [HNLeftMenuViewController new];
    RESideMenu *sideMenuViewController = [[RESideMenu alloc] initWithContentViewController:newsContentView menuViewController:menuViewController];
    sideMenuViewController.backgroundImage = [client retrieveBackgroundImage];
    sideMenuViewController.delegate = self;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = sideMenuViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
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


#pragma mark -
#pragma mark RESideMenu Delegate

- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{

}

- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    
}

- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
   
}

- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    
}


@end
