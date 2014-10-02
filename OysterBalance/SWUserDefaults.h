//
//  SWUserDefaults.h
//  OysterBalance
//
//  Created by Samuel Ward on 25/01/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const rememberMeKey;
extern NSString *const usernameKey;
extern NSString *const passwordKey;

@interface SWUserDefaults : NSObject

+ (void)setupUserDefaultsWithUsername:(NSString *)username password:(NSString *)password rememberMe:(BOOL)rememberMe;

@end
