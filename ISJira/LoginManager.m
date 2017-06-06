//
//  LoginManager.m
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import "LoginManager.h"


@implementation LoginManager


+(LoginManager*)sharedInstance
{
    static LoginManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LoginManager alloc] init];
    });
    return sharedInstance;
}


-(NSString*)getLogin
{
    return[[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
}


-(NSString*)getPassword
{
    return[[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
}


-(void)setLogin:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"login"];
}


-(void)setPassword:(NSString*)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"password"];
}

@end
