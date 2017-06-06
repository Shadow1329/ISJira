//
//  SettingsViewController.m
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import "SettingsViewController.h"


@interface SettingsViewController ()

@end




@implementation SettingsViewController

NSDate *dateFrom;
NSDate *dateTo;
NSDateFormatter *dateFormatter;
bool dateToSelect = false;


// Back to main view
-(IBAction)backButtonClick:(id)sender
{
    // Save settings
    [[SettingsManager sharedInstance] setRange:_mRange.selectedSegmentIndex];
    [[SettingsManager sharedInstance] setDateFrom:dateFrom];
    [[SettingsManager sharedInstance] setDateTo:dateTo];
    
    
    NSArray *projects = [[DataManager sharedInstance] getProjects];
    NSArray *selectedProjectsIndexPaths = [_mProjectsTable indexPathsForSelectedRows];
    NSMutableArray *selectedProjectsKeys = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in selectedProjectsIndexPaths)
    {
        [selectedProjectsKeys addObject:projects[[path row]]];
    }
    [[SettingsManager sharedInstance] setProjects:selectedProjectsKeys];
    
    
    NSArray *users = [[DataManager sharedInstance] getUsers];
    NSArray *selectedUsersIndexPaths = [_mUsersTable indexPathsForSelectedRows];
    NSMutableArray *selectedUsersKeys = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in selectedUsersIndexPaths)
    {
        [selectedUsersKeys addObject:users[[path row]]];
    }
    [[SettingsManager sharedInstance] setUsers:selectedUsersKeys];
    
    
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}




// Back to login view
-(IBAction)logoutButtonClick:(id)sender
{
    [[LoginManager sharedInstance] setLogin:nil];
    [[LoginManager sharedInstance] setPassword:nil];
    [[SettingsManager sharedInstance] setRange:0];
    [[SettingsManager sharedInstance] setDateFrom:nil];
    [[SettingsManager sharedInstance] setDateTo:nil];
    [[SettingsManager sharedInstance] setProjects:nil];
    [[SettingsManager sharedInstance] setUsers:nil];
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self presentViewController:viewController animated:YES completion:nil];
}




// Set range handler
-(IBAction)setRange:(id)sender
{
    int value = ((UISegmentedControl *)sender).selectedSegmentIndex;
    if (value == 2)
    {
        _mDateLabelFrom.hidden = false;
        _mDateViewFrom.hidden = false;
        _mDateSelectFrom.hidden = false;
        _mDateLabelTo.hidden = false;
        _mDateViewTo.hidden = false;
        _mDateSelectTo.hidden = false;
    }
    else
    {
        _mDateLabelFrom.hidden = true;
        _mDateViewFrom.hidden = true;
        _mDateSelectFrom.hidden = true;
        _mDateLabelTo.hidden = true;
        _mDateViewTo.hidden = true;
        _mDateSelectTo.hidden = true;
    }
}




// Select from date
-(IBAction)selectFromDate:(id)sender
{
    _mDatePicker.hidden = false;
    _mDateSetButton.hidden = false;
    _mDatePicker.maximumDate = dateTo;
    _mDatePicker.minimumDate = nil;
    _mDatePicker.date = dateFrom;
    dateToSelect = false;
}




// Select to date
-(IBAction)selectToDate:(id)sender
{
    _mDatePicker.hidden = false;
    _mDateSetButton.hidden = false;
    _mDatePicker.maximumDate = nil;
    _mDatePicker.minimumDate = dateFrom;
    _mDatePicker.date = dateTo;
    dateToSelect = true;
}




// Set date
-(IBAction)setDate:(id)sender
{
    if (dateToSelect)
    {
        dateTo = _mDatePicker.date;
        _mDateViewTo.text = [dateFormatter stringFromDate:dateTo];
    }
    else
    {
        dateFrom = _mDatePicker.date;
        _mDateViewFrom.text = [dateFormatter stringFromDate:dateFrom];
    }
    _mDatePicker.hidden = true;
    _mDateSetButton.hidden = true;
}




// Select projects handler
-(IBAction)selectProjects:(id)sender
{
    _mTableClose.hidden = false;
    _mProjectsTable.hidden = false;
    _mDatePicker.hidden = true;
    _mDateSetButton.hidden = true;
}




// Select users handler
-(IBAction)selectUsers:(id)sender
{
    _mTableClose.hidden = false;
    _mUsersTable.hidden = false;
    _mDatePicker.hidden = true;
    _mDateSetButton.hidden = true;
}




// Close table handler
-(IBAction)closeTable:(id)sender
{
    _mTableClose.hidden = true;
    _mProjectsTable.hidden = true;
    _mUsersTable.hidden = true;
}




// View load
- (void)viewDidLoad {
    [super viewDidLoad];

    // Load settings
    _mUsernameLabel.text = [NSString stringWithFormat:@"Username: %@", [[LoginManager sharedInstance] getLogin]];
    _mRange.selectedSegmentIndex = [[SettingsManager sharedInstance] getRange];
    dateFrom = [[SettingsManager sharedInstance] getDateFrom];
    dateTo = [[SettingsManager sharedInstance] getDateTo];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    _mDateViewFrom.text = [dateFormatter stringFromDate:dateFrom];
    _mDateViewTo.text = [dateFormatter stringFromDate:dateTo];
    if (_mRange.selectedSegmentIndex == 2)
    {
        _mDateLabelFrom.hidden = false;
        _mDateViewFrom.hidden = false;
        _mDateSelectFrom.hidden = false;
        _mDateLabelTo.hidden = false;
        _mDateViewTo.hidden = false;
        _mDateSelectTo.hidden = false;
    }
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0)
    {
        NSArray *projects = [[DataManager sharedInstance] getProjects];
        if (projects)
            return [projects count];
        else
            return 0;
    }
    else
    {
        NSArray *users = [[DataManager sharedInstance] getUsers];
        if (users)
            return [users count];
        else
            return 0;
    }
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (tableView.tag == 0)
    {
        NSArray *projects = [[DataManager sharedInstance] getProjects];
        NSArray *selectedProjects = [[SettingsManager sharedInstance] getProjects];
        if (projects)
        {
            NSString *projectKey = projects[[indexPath row]];
            [cell.textLabel setText: projectKey];
            for (NSString *selectedProject in selectedProjects)
            {
                if ([projectKey isEqualToString:selectedProject])
                {
                    [_mProjectsTable selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionNone];
                    break;
                }
            }
        }
    }
    else
    {
        NSArray *users = [[DataManager sharedInstance] getUsers];
        NSArray *selectedUsers = [[SettingsManager sharedInstance] getUsers];
        if (users)
        {
            NSString *userKey = users[[indexPath row]];
            [cell.textLabel setText: userKey];
            for (NSString *selectedUser in selectedUsers)
            {
                if ([userKey isEqualToString:selectedUser])
                {
                    [_mUsersTable selectRowAtIndexPath:indexPath animated:TRUE scrollPosition:UITableViewScrollPositionNone];
                    break;
                }
            }
        }
    }
    return cell;
}

@end
