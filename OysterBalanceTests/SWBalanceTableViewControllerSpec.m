//
//  SWBalanceTableViewControllerSpec.m
//  OysterBalance
//
//  Created by Samuel Ward on 11/01/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import <Kiwi.h>

#import "SWBalanceTableViewController.h"

SPEC_BEGIN(SWBalanceTableViewControllerSpec)

describe(@"SWBalanceTableViewController", ^{
    
    context(@"Low balance push notifications", ^{
        
        it(@"should have a method called pushLowBalanceNotification", ^{
            
            SWBalanceTableViewController *sut = [[SWBalanceTableViewController alloc] init];
            [[sut should] respondToSelector:@selector(pushLowBalanceNotification)];
            
        });
        
        it(@"should send a push notification", ^{
            
            SWBalanceTableViewController *sut = [[SWBalanceTableViewController alloc] init];
//            [sut pushLowBalanceNotification];
            
            
        });
    });
});

SPEC_END