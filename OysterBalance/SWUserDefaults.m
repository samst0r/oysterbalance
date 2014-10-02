//
//  SWUserDefaults.m
//  OysterBalance
//
//  Created by Samuel Ward on 25/01/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import "SWUserDefaults.h"

NSString *const rememberMeKey = @"remember_me";
NSString *const usernameKey = @"username";
NSString *const passwordKey = @"password";

@implementation SWUserDefaults

+ (void)setupUserDefaultsWithUsername:(NSString *)username password:(NSString *)password rememberMe:(BOOL)rememberMe {
    
    if (rememberMe) {
        
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:usernameKey];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:passwordKey];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:rememberMeKey];
    } else {
        
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:usernameKey];
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:passwordKey];
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:rememberMeKey];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
