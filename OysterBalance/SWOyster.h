//
//  SWOyster.h
//  OysterBalance
//
//  Created by Samuel Ward on 30/11/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWOyster : NSObject

@property (nonatomic) NSNumber *payAsYouGoBalance;
@property (nonatomic) NSNumber *cardNumber;
@property (nonatomic, getter=isValid) BOOL valid;

- (id)initWithPayAsYouGoBalance:(NSNumber *)balance cardNumber:(NSNumber *)cardNumber;

@end
