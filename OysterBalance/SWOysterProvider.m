//
//  SWOysterProvider.m
//  OysterBalance
//
//  Created by Samuel Ward on 30/11/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import "SWOysterProvider.h"

#import <AFNetworking.h>
#import <hpple/TFHpple.h>
#import "SWOyster.h"
#import "SWUser.h"

#import "SWOysterParser.h"
#import "SWOysterManager.h"

// NSUserDefaults...
static NSString *const KEY_USERNAME = @"username";
static NSString *const KEY_PASSWORD = @"password";

// TFL URLs
static NSString *const LOGIN_POST_URL = @"https://account.tfl.gov.uk/Oyster/";
static NSString *const LOGGED_IN_URL = @"https://oyster.tfl.gov.uk/oyster/entry.do";
static NSString *const DETAILS_URL = @"https://oyster.tfl.gov.uk/oyster/loggedin.do";
static NSString *const JOURNEY_HISTORY_URL = @"https://oyster.tfl.gov.uk/oyster/ppvStatementPrint.do";
static NSString *const SELECT_CARD_URL = @"https://oyster.tfl.gov.uk/oyster/selectCard.do";

static NSString *const USER_AGENT = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.73.11 (KHTML, like Gecko) Version/7.0.1 Safari/537.73.11";

@implementation SWOysterProvider

- (BOOL)updateModelWithResponseData:(NSData *)pageData
{
    TFHpple *loginParser = [TFHpple hppleWithHTMLData:pageData];
    
    NSString *error = [[[[loginParser searchWithXPathQuery:@"//*[@id='errormessage']/ul/li"] firstObject] firstChild] content];
    
    BOOL validOyster = NO;
    
    if (!error.length) {
        
        SWOyster *oyster = [[SWOyster alloc] init];
        oyster.payAsYouGoBalance = [SWOysterParser parseBalance:loginParser];
        oyster.cardNumber = [SWOysterParser parseCardNumber:loginParser];
        
        validOyster = (oyster.payAsYouGoBalance && oyster.cardNumber);
        
        if (validOyster) {
            
            [SWOysterManager sharedManager].oyster = oyster;
        }
        
    }
    
    return validOyster && !error;
}

- (void)performLoginWithUser:(SWUser *)user
                  completion:(void (^)(BOOL responseObject, NSError *error))success
{
    NSString *requestStr = [NSString stringWithFormat:@"UserName=%@&Password=%@",
                            user.username, user.password];
    
    NSData *requestData = [NSData dataWithBytes:[requestStr UTF8String] length:[requestStr length]];
    
    NSURL *url = [NSURL URLWithString:LOGIN_POST_URL];

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:requestData];
    [urlRequest setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    [urlRequest setTimeoutInterval:10];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue currentQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error) {
                               
                               NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

                               BOOL status;
                               
                               if (httpResponse.statusCode == 200) {
                                   
                                   if ([self updateModelWithResponseData:data]) {
                                       
                                       status = YES;
                                       error = nil;
                                   } else {
                                       
                                       status = NO;
                                       error = [[NSError alloc] initWithDomain:@"Please check your login details."
                                                                          code:666 userInfo:nil];
                                   }
                                   
                               } else {
                                   
                                   status = NO;
                               }
                               success(status, error);
                               
                               [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                           }
     ];
}


@end
