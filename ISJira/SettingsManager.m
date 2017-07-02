//
//  SettingsManager.m
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import "SettingsManager.h"

@implementation SettingsManager


+(SettingsManager*)sharedInstance
{
    static SettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SettingsManager alloc] init];
    });
    return sharedInstance;
}




-(int)getRange
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"range"];
}


-(NSDate*)getDateFrom
{
    NSDate *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"date_from"];
    if (!result)
        result = [NSDate date];
    return result;
}


-(NSDate*)getDateTo
{
    NSDate *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"date_to"];
    if (!result)
        result = [NSDate date];
    return result;
}


-(NSArray*)getProjects
{
    NSArray *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"projects"];
    if (!result)
        result = [[NSArray alloc] init];
    return result;
}


-(NSArray*)getUsers
{
    NSArray *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"users"];
    if (!result)
        result = [[NSArray alloc] init];
    return result;
}

-(NSDate*)getLastShowingDate
{
    NSDate *result = [[NSUserDefaults standardUserDefaults] objectForKey:@"last_showing_date"];
    return result;
}




-(void)setRange:(int)value
{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:@"range"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setDateFrom:(NSDate *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"date_from"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setDateTo:(NSDate *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"date_to"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setProjects:(NSArray *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"projects"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setUsers:(NSArray *)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"users"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(void)setLastShowingDate:(NSDate*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"last_showing_date"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
