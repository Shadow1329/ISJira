//
//  MainViewController.m
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import "MainViewController.h"



@implementation WorklogTableViewCell

@synthesize mDate = _mDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.mDate.text = @"";
        self.mText.text = @"";
    }
    
    return self;
}

@end




@interface MainViewController ()

@end




@implementation MainViewController

NSMutableArray *worklogTableData;
static NSString *simpleCellIdentifier = @"WorklogCell";


// Get project and write them to UITextView
-(void)getProjects
{
    NSLog(@"Get projects...");
    
    // Prepare data
    NSString *login = [[LoginManager sharedInstance] getLogin];
    NSString *pass = [[LoginManager sharedInstance] getPassword];
    
    if (login && pass)
    {
        NSString *url = [NSString stringWithFormat:@"%@/project", @"http://jira.integrasources.com/rest/api/2"];
        NSString *authPair = [NSString stringWithFormat:@"%@:%@", login, pass];
        NSData *authData = [authPair dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authString = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        NSLog(@"%@", authString);
        
        // Prepare request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authString forHTTPHeaderField:@"Authorization"];
        [request setURL:[NSURL URLWithString:url]];
        
        
        // Send request and get response
        UIAlertView *alert;
        NSHTTPURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSLog(@"Get projects: %li", (long)[response statusCode]);
        
        // Decode response
        if ([response statusCode] == 200)
        {
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0
                                                                           error:nil];
            NSMutableArray *projects = [[NSMutableArray alloc] init];
            for (id key in responseJson)
            {
                NSDictionary *projectDictionary = key;
                NSString* projectKey = [projectDictionary objectForKey:@"key"];
                if (![projects containsObject:projectKey])
                    [projects addObject:projectKey];
            }
            //NSLog(@"%@", projects);
            [[DataManager sharedInstance] setProjects:projects];
        }
        else if([response statusCode] == 403)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login or password incorrect!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login error. Try again!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}




// Get users
-(void)getUsers
{
    NSLog(@"Get users...");
    
    // Prepare data
    NSString *login = [[LoginManager sharedInstance] getLogin];
    NSString *pass = [[LoginManager sharedInstance] getPassword];
    
    if (login && pass)
    {
        NSString *url = [NSString stringWithFormat:@"%@/user/search?startAt=0&maxResults=1000&username=.", @"http://jira.integrasources.com/rest/api/2"];
        NSString *authPair = [NSString stringWithFormat:@"%@:%@", login, pass];
        NSData *authData = [authPair dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authString = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        NSLog(@"%@", authString);
        
        // Prepare request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authString forHTTPHeaderField:@"Authorization"];
        [request setURL:[NSURL URLWithString:url]];
        
        
        // Send request and get response
        UIAlertView *alert;
        NSHTTPURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        NSLog(@"Get users: %li", (long)[response statusCode]);
        
        // Decode response
        if ([response statusCode] == 200)
        {
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0
                                                                           error:nil];
            NSMutableArray *users = [[NSMutableArray alloc] init];
            for (id key in responseJson)
            {
                NSDictionary *userDictionary = key;
                NSString* userKey = [userDictionary objectForKey:@"key"];
                if (![users containsObject:userKey])
                    [users addObject:userKey];
            }
            //NSLog(@"%@", users);
            [[DataManager sharedInstance] setUsers:users];
        }
        else if([response statusCode] == 403)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login or password incorrect!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login error. Try again!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}



// Get issues
-(int)getWorklogsForIssue:(NSString *)issue andAuthor:(NSString *)author andDate:(NSString *)date
{
    // Prepare data
    NSString *login = [[LoginManager sharedInstance] getLogin];
    NSString *pass = [[LoginManager sharedInstance] getPassword];
    int result = -1;
    
    if (login && pass && issue && author)
    {
        NSString *url = [NSString stringWithFormat:@"%@/issue/%@/worklog", @"http://jira.integrasources.com/rest/api/2", issue];
        NSString *authPair = [NSString stringWithFormat:@"%@:%@", login, pass];
        NSData *authData = [authPair dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authString = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        
        // Prepare request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authString forHTTPHeaderField:@"Authorization"];
        [request setURL:[NSURL URLWithString:url]];
        
        
        // Send request and get response
        UIAlertView *alert;
        NSHTTPURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        // Decode response
        if ([response statusCode] == 200)
        {
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0
                                                                           error:nil];
            //NSLog(@"%@", responseJson);
            
            result = 0;
            NSArray *worklogs = [responseJson objectForKey:@"worklogs"];
            for (NSDictionary *worklog in worklogs)
            {
                
                if ([[[worklog objectForKey:@"created"] substringToIndex:10] isEqualToString:date])
                {
                    result += [[worklog objectForKey:@"timeSpentSeconds"] intValue];
                }
            }
        }
        else if([response statusCode] == 403)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login or password incorrect!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login error. Try again!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    return result;
}




// Get worklog
-(int)getWorklogForAuthor:(NSString *)author andDate:(NSString *)date
{
    // Prepare data
    NSString *login = [[LoginManager sharedInstance] getLogin];
    NSString *pass = [[LoginManager sharedInstance] getPassword];
    int result = -1;
    
    if (login && pass && author && date)
    {
        NSString *url = [NSString stringWithFormat:@"%@/search?startIndex=0&maxResults=100&fields=key&jql=worklogDate=%@+and+worklogAuthor=%@",
                         @"http://jira.integrasources.com/rest/api/2", date, author];
        NSString *authPair = [NSString stringWithFormat:@"%@:%@", login, pass];
        NSData *authData = [authPair dataUsingEncoding:NSUTF8StringEncoding];
        NSString *authString = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];
        
        // Prepare request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:authString forHTTPHeaderField:@"Authorization"];
        [request setURL:[NSURL URLWithString:url]];
        
        
        // Send request and get response
        UIAlertView *alert;
        NSHTTPURLResponse *response = nil;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        
        // Decode response
        if ([response statusCode] == 200)
        {
            NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0
                                                                           error:nil];
            //NSLog(@"%@", responseJson);
            
            result = 0;
            NSArray *issues = [responseJson objectForKey:@"issues"];
            
            for (NSDictionary *issue in issues)
            {
                result += [self getWorklogsForIssue:[issue objectForKey:@"key"] andAuthor:author andDate:date];
            }
        }
        else if([response statusCode] == 403)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login or password incorrect!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                               message:@"Login error. Try again!"
                                              delegate:nil
                                     cancelButtonTitle:@"Ok"
                                     otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    return result;
}




// Get worklog
-(void)getWorklog
{
    NSLog(@"Get worklog...");
    
    // Clear old data
    [worklogTableData removeAllObjects];
    
    NSDateFormatter *dateFormatterQuerry = [[NSDateFormatter alloc] init];
    NSDateFormatter *dateFormatterTitle = [[NSDateFormatter alloc] init];
    [dateFormatterQuerry setDateFormat:@"YYYY-MM-dd"];
    [dateFormatterTitle setDateFormat:@"EEEE, MMM dd"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    NSDate *fromDate;
    NSDate *toDate;
    NSDate *curDate;
    
    int dateType = [[SettingsManager sharedInstance] getRange];
    switch(dateType)
    {
        case 0:
            components.day = -7;
            toDate = [NSDate date];
            fromDate = [calendar dateByAddingComponents:components toDate:toDate options:0];
            break;
            
        case 1:
            components.month = -1;
            toDate = [NSDate date];
            fromDate = [calendar dateByAddingComponents:components toDate:toDate options:0];
            break;
            
        case 2:
            toDate = [[SettingsManager sharedInstance] getDateTo];
            fromDate = [[SettingsManager sharedInstance] getDateFrom];
            break;
    }
    components.month = 0;
    components.day = -1;
    
    
    // Fetch data from server
    NSArray *users = [[SettingsManager sharedInstance] getUsers];
    if (users.count > 0)
    {
        NSCalendar *daysCalendar = [NSCalendar currentCalendar];
        
        [daysCalendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                     interval:NULL forDate:fromDate];
        [daysCalendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                     interval:NULL forDate:toDate];
        
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                   fromDate:fromDate toDate:toDate options:0];
        
        curDate = [toDate copy];
        
        for (int i = 0; i < [difference day]; i++)
        {
            NSString *result = @"";
            for (NSString *user in users)
            {
                result = [NSString stringWithFormat:@"%@\n%@ = %fh", result, user, (float)[self getWorklogForAuthor:user andDate:[dateFormatterQuerry stringFromDate:curDate]] / 3600.0f];
            }
            NSDictionary *dictionary = @{@"date":[dateFormatterTitle stringFromDate:curDate], @"text":result};
            [worklogTableData addObject:dictionary];
            curDate = [calendar dateByAddingComponents:components toDate:curDate options:0];
        }
    }

    
    // Reload table
    [_mWorklogTables reloadData];
}




// Click on settings button
-(IBAction)settingsButtonClick:(id)sender
{
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}




// Callback for tableview cells count
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [worklogTableData count];
}




// Callback for tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorklogTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *info = [worklogTableData objectAtIndex:indexPath.row];
    cell.mDate.text = [info objectForKey:@"date"];
    cell.mText.text = [info objectForKey:@"text"];
    return cell;
}




// Height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat base = 80;
    
    NSArray *users = [[SettingsManager sharedInstance] getUsers];
    if (users)
    {
        base += 20 * [users count];
    }
    
    return base;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    worklogTableData = [NSMutableArray arrayWithObjects:@"Egg Benedict", nil];
    
    // Get projects list
    if (![[DataManager sharedInstance] getProjects])
        [self getProjects];
    
    // Get users list
    if (![[DataManager sharedInstance] getUsers])
        [self getUsers];
    
    // Get worklog
    [self getWorklog];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
