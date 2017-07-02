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

NSArray *worklogTableData;
static NSString *simpleCellIdentifier = @"WorklogCell";









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
    
    worklogTableData = [NSMutableArray arrayWithObjects:@{@"date":@"", @"text":@""}, nil];
    
    // Start GPS Service
    [[GPSService sharedInstance] start];
}


-(void)viewWillAppear:(BOOL)animated {
    _mGATracker = [[GAI sharedInstance] defaultTracker];
    [_mGATracker set:kGAIScreenName value:@"Main Screen"];
    [_mGATracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Get projects list
        if (![[DataManager sharedInstance] getProjects])
        [[JiraManager sharedInstance] getProjects];
        
        // Get users list
        if (![[DataManager sharedInstance] getUsers])
        [[JiraManager sharedInstance] getUsers];
        
        // Get worklog
        [[JiraManager sharedInstance] getWorklogs];
        if ([[DataManager sharedInstance] getWorklogs])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                worklogTableData = [[DataManager sharedInstance] getWorklogs];
                [_mWorklogTables reloadData];
                
                // Send successful getting worklog
                [_mGATracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ISJira"
                                                                          action:@"Get worklog list"
                                                                           label:@"Success"
                                                                           value:@1] build]];
            });
        }
    });
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
