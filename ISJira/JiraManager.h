#import <Foundation/Foundation.h>
#import "LoginManager.h"
#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "SettingsManager.h"


@interface JiraManager : NSObject

+(JiraManager*)sharedInstance;

-(void)getProjects;
-(void)getUsers;
-(void)getWorklogs;
-(int)getWorklogForAuthor:(NSString *)author andDate:(NSString *)date;

@end
