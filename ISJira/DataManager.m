//
//  DataManager.m
//  ISJira
//
//  Created by Admin on 04.05.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager


+(DataManager*)sharedInstance
{
    static DataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DataManager alloc] init];
    });
    return sharedInstance;
}




-(NSArray*)getProjects
{
    return mProjects;
}


-(NSArray*)getUsers
{
    return mUsers;
}
    

-(NSArray*)getWorklogs
{
    return mWorklogs;
}




-(void)setProjects:(NSArray*)value
{
    mProjects = value;
}


-(void)setUsers:(NSArray*)value
{
    mUsers = value;
}
    
    
-(void)setWorklogs:(NSArray*)value
{
    mWorklogs = value;
}

@end
