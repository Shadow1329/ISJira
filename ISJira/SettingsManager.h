//
//  SettingsManager.h
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject

+(SettingsManager*)sharedInstance;

-(int)getRange;
-(NSDate*)getDateFrom;
-(NSDate*)getDateTo;
-(NSArray*)getProjects;
-(NSArray*)getUsers;

-(void)setRange:(int)value;
-(void)setDateFrom:(NSDate*)value;
-(void)setDateTo:(NSDate*)value;
-(void)setProjects:(NSArray*)value;
-(void)setUsers:(NSArray*)value;;

@end
