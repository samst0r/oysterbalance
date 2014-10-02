//
//  SWPNSManager.m
//  OysterBalance
//
//  Created by Samuel Ward on 12/01/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import "SWPNSManager.h"

@implementation SWPNSManager

+ (void)pushLowBalanceNotification {
    
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil)
        return;
    
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:10];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"%@.", nil),
                            @"Your Oyster Card balance is running low"];
    localNotification.alertAction = NSLocalizedString(@"View Details", nil);
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"raf raf raf" forKey:@"RafKey"];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
