//
//  SWOysterProvider.h
//  OysterBalance
//
//  Created by Samuel Ward on 30/11/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SWUser;

@interface SWOysterProvider : NSObject

- (void)performLoginWithUser:(SWUser *)user
                  completion:(void (^)(BOOL responseObject, NSError *error))success;

@end
