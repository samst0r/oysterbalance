//
//  SWOyster.m
//  OysterBalance
//
//  Created by Samuel Ward on 30/11/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import "SWOyster.h"

@implementation SWOyster

- (id)initWithPayAsYouGoBalance:(NSNumber *)balance cardNumber:(NSNumber *)cardNumber
{
    self = [super init];
    if (self) {
        
        _payAsYouGoBalance = balance;
        _cardNumber = cardNumber;
    }
    return self;
}

@end
