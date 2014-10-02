//
//  SWBalanceTableViewController.m
//  OysterBalance
//
//  Created by Samuel Ward on 01/12/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import "SWBalanceTableViewController.h"

#import "SWOyster.h"
#import "SWViewController.h"
#import "SWOysterProvider.h"
#import "SWOysterManager.h"
#import "SWUserManager.h"

#import <QuartzCore/QuartzCore.h>

NSString *const lowBalanceNotificationsKey = @"low_balance_notifications";

@interface SWBalanceTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *lowBalanceNotificationCell;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)refresh:(id)sender;
- (IBAction)logout:(id)sender;

@end

@implementation SWBalanceTableViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self setupLogoutButton];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self moveBalanceLabelFromLeftOffscreenToCentreScreen];
}

- (void)setupLogoutButton {
    
    self.logoutButton.layer.borderWidth = 1.0f;
    self.logoutButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.logoutButton.layer.cornerRadius = 3.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    BOOL rememberMe = [[NSUserDefaults standardUserDefaults] boolForKey:rememberMeKey];
    
    if (!rememberMe) {
        
        self.lowBalanceNotificationCell.hidden = YES;
    }
    
    if (![[SWOysterManager sharedManager].oyster.payAsYouGoBalance.stringValue isEqualToString:@""]) {
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];

        [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        formatter.locale = [NSLocale currentLocale];
        self.balanceLabel.text = [formatter stringFromNumber:[SWOysterManager sharedManager].oyster.payAsYouGoBalance];
    }
    
    if (![[SWOysterManager sharedManager].oyster.cardNumber.stringValue isEqualToString:@""]){
        self.cardNumberLabel.text = [NSString stringWithFormat:@"Card No: %@", [SWOysterManager sharedManager].oyster.cardNumber];
    }
}

- (IBAction)logout:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)moveBalanceLabelFromCentreToRightOffscreen {
    
    [UIView animateWithDuration:0.25f
                          delay:0.25f
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGPoint center = self.balanceLabel.center;
                         center = CGPointMake(500.0f, center.y);
                         self.balanceLabel.center = center;
                     }
                     completion:nil];
}

- (void)moveBalanceLabelToLeftOffScreen {
    
    CGPoint startingCenter = self.balanceLabel.center;
    startingCenter = CGPointMake(-500.0f, startingCenter.y);
    self.balanceLabel.center = startingCenter;
}

- (void)moveBalanceLabelFromLeftOffscreenToCentreScreen {
    
    [self moveBalanceLabelToLeftOffScreen];
    
    self.balanceLabel.hidden = NO;
    
    [UIView animateWithDuration:0.25f
                          delay:0.25f
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.2
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         CGPoint finalCenter = self.balanceLabel.center;
                         finalCenter = CGPointMake(self.tableView.center.x, finalCenter.y);
                         
                         self.balanceLabel.center = finalCenter;
                     }
                     completion:nil];
}

- (IBAction)refresh:(id)sender {
    
    [self moveBalanceLabelFromCentreToRightOffscreen];

    SWOysterProvider *oysterProvider = [[SWOysterProvider alloc] init];
    
    [oysterProvider performLoginWithUser:[SWUserManager sharedManager].user completion:^(BOOL responseObject, NSError *error) {
       
        [self.refreshControl endRefreshing];
        
        [self moveBalanceLabelFromLeftOffscreenToCentreScreen];
    }];
}

@end
