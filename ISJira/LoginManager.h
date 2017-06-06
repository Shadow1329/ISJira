//
//  LoginManager.h
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginManager : NSObject

+(LoginManager*)sharedInstance;
-(NSString*)getLogin;
-(NSString*)getPassword;
-(void)setLogin:(NSString*)value;
-(void)setPassword:(NSString*)value;

@end
