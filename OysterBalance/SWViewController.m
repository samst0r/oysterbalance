  //
//  SWViewController.m
//  OysterBalance
//
//  Created by Sam Ward on 09/11/2013.
//  Copyright (c) 2013 Sam Ward. All rights reserved.
//

#import "SWViewController.h"
#import "UIColor+Colors.h"

#import "AFNetworking.h"

#import "SWOysterProvider.h"
#import "SWBalanceTableViewController.h"
#import "SWOyster.h"
#import "SWUser.h"
#import "SWUserDefaults.h"

#import "SWOysterManager.h"
#import "SWUserManager.h"

static NSString *const loginURL = @"https://oyster.tfl.gov.uk/oyster/link/0004.do";

@interface SWViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UISwitch *rememberMe;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic) UIView *darkenOverlayView;

@property (nonatomic) UIDynamicAnimator* animator;
@property (nonatomic) UIAttachmentBehavior* attachmentBehavior;

@property (nonatomic) SWOysterProvider *oysterProvider;

- (IBAction)login:(id)sender;
- (IBAction)registerWithSafari:(id)sender;

@end

@implementation SWViewController

- (void)setupDarkenOverlayView {
    
    self.darkenOverlayView = [[UIView alloc] initWithFrame:self.view.frame];
    self.darkenOverlayView.backgroundColor = [UIColor blackColor];
    self.darkenOverlayView.opaque = NO;
    self.darkenOverlayView.alpha = 0.0f;
    
    [self.view insertSubview:self.darkenOverlayView belowSubview:self.containerView];
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.username.delegate = self;
    self.password.delegate = self;
    
    [SWUserManager sharedManager].user = [[SWUser alloc] initWithUsername:[[NSUserDefaults standardUserDefaults] stringForKey:usernameKey]
                                                                 password:[[NSUserDefaults standardUserDefaults] stringForKey:passwordKey]
                                                               rememberMe:[[NSUserDefaults standardUserDefaults] boolForKey:rememberMeKey]];
    
    [self populateFields];
    
    [self setupDarkenOverlayView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(snapContainerViewWithOffsetForKeyboard) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self hideDarkenOverlayView];
    [[NSNotificationCenter defaultCenter] removeObserver:UIKeyboardWillShowNotification];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.activityView stopAnimating];
    [self hideDarkenOverlayView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    double delayInSeconds = 0.3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [self snapContainerToCenter];
    });
}

- (void)viewDidLayoutSubviews {
    
    self.containerView.center = CGPointMake(self.containerView.center.x + 700,
                                            self.containerView.center.y);
}

#pragma mark - Snapping Animations

- (void)snapContainerToCenter {
    
    [self.animator removeAllBehaviors];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.containerView]];
    itemBehaviour.elasticity = 0.6;
    itemBehaviour.allowsRotation = YES;
    
    UIAttachmentBehavior *attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.containerView
                                                                           attachedToAnchor:CGPointMake(self.view.center.x, self.view.center.y)];
    [attachmentBehaviour setFrequency:3];
    [attachmentBehaviour setDamping:0.5];
    [attachmentBehaviour setLength:2];
    
    [self.animator addBehavior:itemBehaviour];
    [self.animator addBehavior:attachmentBehaviour];
}

- (void)snapContainerViewWithOffsetForKeyboard {

    [self.animator removeAllBehaviors];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UIDynamicItemBehavior* itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.containerView]];
    itemBehaviour.elasticity = 0.8;
    itemBehaviour.allowsRotation = YES;
    
    UIAttachmentBehavior *attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.containerView
                                                                          attachedToAnchor:CGPointMake(self.view.center.x, self.view.center.y - 100)];
    [attachmentBehaviour setFrequency:2];
    [attachmentBehaviour setDamping:0.5];
    [attachmentBehaviour setLength:2];
    
    [self.animator addBehavior:itemBehaviour];
    [self.animator addBehavior:attachmentBehaviour];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSInteger nextTag = textField.tag + 1;

    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];

    if (nextResponder) {
        
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        
        [self snapContainerToCenter];
    }
    
    return NO;
}

- (void)hideDarkenOverlayView {
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.darkenOverlayView.alpha = 0.0f;
    }];
}

- (void)showDarkenOverlayView {
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.darkenOverlayView.alpha = 0.5f;
    }];
}

- (IBAction)login:(id)sender {

    [self.username resignFirstResponder];
    [self.password resignFirstResponder];

    [self showDarkenOverlayView];
    [self snapContainerToCenter];
    
    if (self.username.text.length > 2 &&
        self.password.text.length > 2) {
        
        [self.activityView startAnimating];
        
        self.oysterProvider = [[SWOysterProvider alloc] init];
    
        [SWUserManager sharedManager].user = [[SWUser alloc] initWithUsername:self.username.text
                                                                     password:self.password.text
                                                                   rememberMe:self.rememberMe.on];
                     
        [self.oysterProvider performLoginWithUser:[SWUserManager sharedManager].user
                                       completion:^(BOOL success, NSError *error) {
                                           
                                           if (success) {
                                               
                                               [SWUserDefaults setupUserDefaultsWithUsername:self.username.text
                                                                                    password:self.password.text
                                                                                  rememberMe:self.rememberMe.on];
                                               
                                               [self performSegueWithIdentifier:@"balanceTableSegue" sender:self];
                                               
                                           } else {
                                               
                                               [self stopActivityViewAndShowLoginInIssuesError:error];
                                           }
                                       }];
    } else {
        
        [self stopActivityViewAndShowInvalidLoginError];
    }
}

- (void)stopActivityViewAndShowInvalidLoginError {
    
    [self.activityView stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Login!" message:@"Please correct your username and/or password" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];
    
    [self hideDarkenOverlayView];
}

- (void)stopActivityViewAndShowLoginInIssuesError:(NSError *)error {
    
    [self.activityView stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"There was a problem!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
    
    [alert show];

    [self hideDarkenOverlayView];
}

- (IBAction)registerWithSafari:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:loginURL]];
}

- (void)populateFields {
    
    if ([SWUserManager sharedManager].user.isValidAndWantsToBeRemembered) {
        
        self.username.text = [SWUserManager sharedManager].user.username;
        self.password.text = [SWUserManager sharedManager].user.password;
        self.rememberMe.on = [SWUserManager sharedManager].user.rememberMe;
    } else {
        
        self.username.text = @"";
        self.password.text = @"";
    }
}

@end
