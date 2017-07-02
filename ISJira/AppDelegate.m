//
//  AppDelegate.m
//  ISJira
//
//  Created by Admin on 26.02.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end


@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end


@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Google analytics
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);

    // Notifications permission
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound categories:nil]];
    }
    
    // Start GPS service
    [[GPSService sharedInstance] setDelegate:self];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Stop GPS service
    [[GPSService sharedInstance] stop];
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIApplicationState appState = UIApplicationStateActive;
    if ([application respondsToSelector:@selector(applicationState)])
        appState = application.applicationState;
    
    if (appState != UIApplicationStateActive)
    {
        // Open JIRA website
        NSURL *siteURL = [NSURL URLWithString:@"https://jira.integrasources.com/"];
        if ([[UIApplication sharedApplication] canOpenURL:siteURL]) {
            [[UIApplication sharedApplication] openURL:siteURL];
        }
    }
}


// Device get ouside region
-(void)outsideLocation:(int)distance {
    
    NSDateFormatter *dateFormatterQuerry = [[NSDateFormatter alloc] init];
    [dateFormatterQuerry setDateFormat:@"YYYY-MM-dd"];
    
    float workLog = (float)[[JiraManager sharedInstance] getWorklogForAuthor:[[LoginManager sharedInstance] getLogin] andDate:[dateFormatterQuerry stringFromDate:[NSDate date]]] / 3600.0f;
    
    NSLog(@"User = %@, Worklog = %f", [[LoginManager sharedInstance] getLogin], workLog);
    
    if (workLog < 4.0)
    {
        [self showPushNotification];
    }
}


// Device get inside region
-(void)insideLocation:(int)distance {
    
}


// Show notification
-(void)showPushNotification {
    if (![self checkSilenceTime])
    {
        [[SettingsManager sharedInstance] setLastShowingDate:[NSDate date]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1.0f];
            notification.alertBody = @"You forgot to log time in JIRA. Do it right now!";
            notification.alertAction = @"Ok";
            notification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        });
    }
}


// Check for silence time
-(bool)checkSilenceTime {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSArray *holidaysArray = [NSArray arrayWithObjects:
                      @"01/01",
                      @"02/01",
                      @"07/01",
                      @"23/02",
                      @"08/03",
                      @"01/05",
                      @"02/05",
                      @"09/05",
                      @"12/06",
                      @"04/11",
                      nil];
    
    NSDate* currentDate = [NSDate date];
    NSDateComponents* curDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth |NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitWeekday fromDate:currentDate];
    
    
    // Check for daily show
    NSDate* lastShowingDate = [[SettingsManager sharedInstance] getLastShowingDate];
    if (lastShowingDate)
    {
        NSDateComponents* lastShowingDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear fromDate:lastShowingDate];
        
        if (curDateComponents.year == lastShowingDateComponents.year && curDateComponents.month == lastShowingDateComponents.month && curDateComponents.day == lastShowingDateComponents.day) {
            NSLog(@"Showing denied - already shown today");
            return true;
        }
    }
    
    
    // Check for weekend
    if (curDateComponents.weekday == 1 && curDateComponents.weekday == 7) {
        NSLog(@"Showing denied - weekend");
        return true;
    }
    
    
    // Check for holidays
    for (NSString* holiday in holidaysArray)
    {
        NSDate* holidayDate = [dateFormatter dateFromString:holiday];
        NSDateComponents* holidayDateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth|NSCalendarUnitDay fromDate:holidayDate];
        
        if (curDateComponents.month == holidayDateComponents.month && curDateComponents.day == holidayDateComponents.day) {
            NSLog(@"Showing denied - holiday: %@", holiday);
            return true;
        }
    }
    
    NSLog(@"Showing granted");
    return false;
}

@end
