//
//  SWOysterManager.h
//  OysterBalance
//
//  Created by Samuel Ward on 22/02/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SWOyster;

@interface SWOysterManager : NSObject

@property (nonatomic, retain) SWOyster *oyster;

+ (SWOysterManager *)sharedManager;

@end
