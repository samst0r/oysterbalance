//
//  SWUser.m
//  OysterBalance
//
//  Created by Samuel Ward on 11/01/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import "SWUser.h"

@implementation SWUser

- (id)initWithUsername:(NSString *)username password:(NSString *)password rememberMe:(BOOL)rememberMe
{
    self = [super init];
    if (self) {
        
        _username = username;
        _password = password;
        _rememberMe = rememberMe;
        
    }
    return self;
}

- (BOOL)isValidAndWantsToBeRemembered {
    
    return (self.username && self.password && self.shouldRememberMe);
}

@end
