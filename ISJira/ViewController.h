//
//  ViewController.h
//  ISJira
//
//  Created by Admin on 26.02.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "LoginManager.h"
#import "MainViewController.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *mLogin;
@property (strong, nonatomic) IBOutlet UITextField *mPassword;
@property (strong, nonatomic) IBOutlet UIButton *mLoginButton;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *mActivityIndicator;
@property (nonatomic) UITapGestureRecognizer *mTapRecognizer;

@property (strong, nonatomic) id<GAITracker> mGATracker;

-(IBAction)loginButtonClick:(id)sender;

@end

