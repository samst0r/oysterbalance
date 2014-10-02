//
//  SWUserManager.h
//  OysterBalance
//
//  Created by Samuel Ward on 22/02/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWUser.h"

@interface SWUserManager : NSObject

@property (nonatomic, retain) SWUser *user;

+ (SWUserManager *)sharedManager;

@end
