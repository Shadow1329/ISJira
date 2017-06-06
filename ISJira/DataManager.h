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
}

+(DataManager*)sharedInstance;

-(NSArray*)getProjects;
-(NSArray*)getUsers;

-(void)setProjects:(NSArray*)value;
-(void)setUsers:(NSArray*)value;

@end
