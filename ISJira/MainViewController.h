//
//  MainViewController.h
//  ISJira
//
//  Created by Admin on 30.04.17.
//  Copyright (c) 2017 Integra Sources. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginManager.h"
#import "DataManager.h"
#import "SettingsManager.h"


@interface WorklogTableViewCell: UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mDate;
@property (strong, nonatomic) IBOutlet UITextView *mText;

@end




@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *mWorklogTables;
@property (strong, nonatomic) IBOutlet UIButton *mSettingsButton;

-(IBAction)settingsButtonClick:(id)sender;

@end
