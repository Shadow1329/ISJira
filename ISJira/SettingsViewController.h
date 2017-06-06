//
//  SettingsViewController.h
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginManager.h"
#import "DataManager.h"
#import "SettingsManager.h"

@interface SettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *mUsernameLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *mRange;
@property (strong, nonatomic) IBOutlet UILabel *mDateLabelFrom;
@property (strong, nonatomic) IBOutlet UILabel *mDateViewFrom;
@property (strong, nonatomic) IBOutlet UIButton *mDateSelectFrom;
@property (strong, nonatomic) IBOutlet UILabel *mDateLabelTo;
@property (strong, nonatomic) IBOutlet UILabel *mDateViewTo;
@property (strong, nonatomic) IBOutlet UIButton *mDateSelectTo;
@property (strong, nonatomic) IBOutlet UIDatePicker *mDatePicker;
@property (strong, nonatomic) IBOutlet UIButton *mDateSetButton;

@property (strong, nonatomic) IBOutlet UITableView *mProjectsTable;
@property (strong, nonatomic) IBOutlet UITableView *mUsersTable;
@property (strong, nonatomic) IBOutlet UIButton *mTableClose;


-(IBAction)backButtonClick:(id)sender;
-(IBAction)logoutButtonClick:(id)sender;
-(IBAction)setRange:(id)sender;
-(IBAction)selectFromDate:(id)sender;
-(IBAction)selectToDate:(id)sender;
-(IBAction)setDate:(id)sender;
-(IBAction)selectProjects:(id)sender;
-(IBAction)selectUsers:(id)sender;
-(IBAction)closeTable:(id)sender;

@end
