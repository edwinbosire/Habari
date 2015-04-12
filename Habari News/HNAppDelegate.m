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
#import <Parse/Parse.h>

#define kApplicationID @"c4o4qrzihavbdWmyH933RxA9XrUEbAqTwWmpXM2j"
#define kClientKey @"YmAJ0W0fpxcQRIgtDz4bsEQqJI6CHj6Db53vYeCF"

typedef NS_OPTIONS(NSUInteger, SectionIdentifier) {
    sectionTypePopular = 0,
    sectionTypePolitics = 1
};
@implementation HNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //Push Notifications
    
    [Parse setApplicationId:kApplicationID clientKey:kClientKey];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:40*1024*1024
                                                      diskCapacity:50*1024*1024
                                                          diskPath:@"app_cache"];
    
    // Set the shared cache to our new  instance
    [NSURLCache setSharedURLCache:cache];
    
    [[XLCircleProgressIndicator appearance] setStrokeProgressColor:[UIColor wetAsphaltColor]];
    
    // remaining color, gray color in the example image
    [[XLCircleProgressIndicator appearance] setStrokeRemainingColor:[UIColor asbestosColor]];
    
    //In order to set up the circle stroke's width you can choose between these 2 ways.
    [[XLCircleProgressIndicator appearance] setStrokeWidth:6.0f];
    
    HNClient *client = [HNClient shareClient];
    HNSection *politicsSection = [HNSection sectionForID:@(sectionTypePolitics)];
    
    HNGenericNewsViewController *latestViewController = [[HNGenericNewsViewController alloc] initWithItem:politicsSection];
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


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}
@end
