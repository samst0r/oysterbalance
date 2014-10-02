//
//  SWOysterParser.h
//  OysterBalance
//
//  Created by Samuel Ward on 09/02/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TFHpple;

@interface SWOysterParser : NSObject

+ (NSNumber *)parseCardNumber:(TFHpple *)loginParser;
+ (NSNumber *)parseBalance:(TFHpple *)loginParser;

@end
