//
//  SWUser.h
//  OysterBalance
//
//  Created by Samuel Ward on 11/01/2014.
//  Copyright (c) 2014 Sam Ward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWUser : UITableViewCell

@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *password;
@property (nonatomic, getter=shouldRememberMe) BOOL rememberMe;

@property (nonatomic, getter=isValidAndWantsToBeRemembered) BOOL valid;

- (id)initWithUsername:(NSString *)username password:(NSString *)password rememberMe:(BOOL)rememberMe;

@end
