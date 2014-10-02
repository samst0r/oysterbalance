//
//  SWAppDelegate.m
//  OysterBalance
//
//  Created by Sam Ward on 09/11/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import "SWAppDelegate.h"
#import "SWOysterProvider.h"
#import "SWViewController.h"
#import "SWOyster.h"
#import "SWPNSManager.h"
#import "SWUser.h"
#import "SWOysterManager.h"

@implementation SWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSTimeInterval sixHours = 60*60*6;
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:sixHours];

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
        application.applicationIconBadgeNumber = 0;
}
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"########### Received Background Fetch ###########");
    
    [self refreshBalanceForFetchWithCompletionHandler:completionHandler];
}

- (void)refreshBalanceForFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    SWUser *user = [[SWUser alloc] initWithUsername:[[NSUserDefaults standardUserDefaults] stringForKey:usernameKey]
                                           password:[[NSUserDefaults standardUserDefaults] stringForKey:passwordKey]
                                         rememberMe:[[NSUserDefaults standardUserDefaults] boolForKey:rememberMeKey]];

    if (user.isValidAndWantsToBeRemembered) {
        
        SWOysterProvider *oysterProvider = [[SWOysterProvider alloc] init];
        [oysterProvider performLoginWithUser:user
                                  completion:^(BOOL success, NSError *error) {
                                      
                                      if (success) {
                                          
                                          if ([[SWOysterManager sharedManager].oyster.payAsYouGoBalance doubleValue] <= 5.50) {
                                              
                                              [SWPNSManager pushLowBalanceNotification];
                                          }
                                          
                                          completionHandler(UIBackgroundFetchResultNewData);
                                      }
                                  }];

    } else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

@end
