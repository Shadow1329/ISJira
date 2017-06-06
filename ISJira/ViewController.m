//
//  ViewController.m
//  ISJira
//
//  Created by Michail Efimenko on 26.02.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import "ViewController.h"




@interface ViewController ()

@end




@implementation ViewController


// Check login and password
-(void)checkLogin:(NSString*)login andPassword:(NSString*)password
{
    NSLog(@"Check login...");
    
    // Disable views
    _mActivityIndicator.hidden = false;
    _mLoginButton.enabled = false;
    _mLogin.enabled = false;
    _mPassword.enabled = false;
    
    // Prepare data
    NSString *url = [NSString stringWithFormat:@"%@/project", @"https://jira.integrasources.com/rest/api/2"];
    NSString *authPair = [NSString stringWithFormat:@"%@:%@", login, password];
    NSData *authData = [authPair dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authString = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
    NSLog(@"%@", authString);
    
    // Prepare request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authString forHTTPHeaderField:@"Authorization"];
    [request setURL:[NSURL URLWithString:url]];
    
    
    // Send request and get response
    UIAlertView *alert;
    NSHTTPURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    NSLog(@"Check login: %li", (long)[response statusCode]);
    
    // Decode response
    if ([response statusCode] == 200)
    {
        [[LoginManager sharedInstance] setLogin: login];
        [[LoginManager sharedInstance] setPassword: password];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
            [self presentViewController:viewController animated:YES completion:nil];
        });
        return;
    }
    else if([response statusCode] == 403)
    {
        [[LoginManager sharedInstance] setLogin: nil];
        [[LoginManager sharedInstance] setPassword: nil];
        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:@"Login or password incorrect!"
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:@"Login error. Try again!"
                                          delegate:nil
                                 cancelButtonTitle:@"Ok"
                                 otherButtonTitles:nil, nil];
        [alert show];
    }
    
    // If checking not passed - enable views
    _mLoginButton.enabled = true;
    _mLogin.enabled = true;
    _mLogin.text = @"";
    _mPassword.enabled = true;
    _mPassword.text = @"";
    _mActivityIndicator.hidden = true;
}




// Login button click
-(IBAction)loginButtonClick:(id)sender
{
    [self checkLogin:_mLogin.text andPassword:_mPassword.text];
}




// Handle tap and close keyboard
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}




// Load view
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    _mTapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:_mTapRecognizer];
    
    NSLog(@"Login - %@", [[LoginManager sharedInstance] getLogin]);
    NSLog(@"Passw - %@", [[LoginManager sharedInstance] getPassword]);
    
    NSString* login = [[LoginManager sharedInstance] getLogin];
    NSString* password = [[LoginManager sharedInstance] getPassword];
    if (login && password)
    {
        _mLogin.text = login;
        _mPassword.text = password;
        [self checkLogin:login andPassword:password];
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
