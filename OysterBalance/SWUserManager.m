//
//  SWUserManager.m
//  OysterBalance
//
//  Created by Samuel Ward on 22/02/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import "SWUserManager.h"
#import "SWOysterManager.h"

#import "SWUser.h"

@implementation SWUserManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    
    static SWOysterManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
        
        _user = [[SWUser alloc] init];
    }
    return self;
}

@end
