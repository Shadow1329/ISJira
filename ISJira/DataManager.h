//
//  DataManager.h
//  ISJira
//
//  Created by Admin on 04.05.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject
{
    NSArray *mProjects;
    NSArray *mUsers;
    NSArray *mWorklogs;
}

+(DataManager*)sharedInstance;

-(NSArray*)getProjects;
-(NSArray*)getUsers;
-(NSArray*)getWorklogs;

-(void)setProjects:(NSArray*)value;
-(void)setUsers:(NSArray*)value;
-(void)setWorklogs:(NSArray*)value;

@end
