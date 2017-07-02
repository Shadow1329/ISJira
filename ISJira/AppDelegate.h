//
//  AppDelegate.h
//  ISJira
//
//  Created by Admin on 26.02.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Google/Analytics.h>
#import "ViewController.h"
#import "GPSService.h"
#import "SettingsManager.h"
#import "LoginManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GPSServiceDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

