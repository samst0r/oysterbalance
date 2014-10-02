//
//  SWOysterParser.m
//  OysterBalance
//
//  Created by Samuel Ward on 09/02/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import "SWOysterParser.h"

#import <TFHpple.h>

@implementation SWOysterParser

+ (NSNumber *)parseCardNumber:(TFHpple *)loginParser
{
    NSString *cardNumberXPathQueryString = @"//*[@id='sectionmenu']/h2";
    NSArray *cardNodes = [loginParser searchWithXPathQuery:cardNumberXPathQueryString];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *cardNumber;
    
    if (cardNodes.count) {
        
        cardNumber = [[[cardNodes[0] firstChild] content] substringFromIndex:9];
    }
    
    return [formatter numberFromString:cardNumber];
}

+ (NSNumber *)parseBalance:(TFHpple *)loginParser
{
    NSString *balanceXpathQueryString =  @"//*[@id=\"contentbox\"]/div[7]/span";
    NSArray *loginNodes = [loginParser searchWithXPathQuery:balanceXpathQueryString];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *rawBalanceString;
    
    if (loginNodes.count) {
        
        rawBalanceString = [[loginNodes[0] firstChild] content];
        rawBalanceString = [rawBalanceString substringFromIndex:10];
    }
    
    return [formatter numberFromString:rawBalanceString];
}

@end
