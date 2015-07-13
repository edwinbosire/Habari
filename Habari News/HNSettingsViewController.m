//
//  HNSettingsViewController.m
//  Habari News
//
//  Created by edwin bosire on 16/01/2014.
//  Copyright (c) 2014 Edwin Bosire. All rights reserved.
//

#import "HNSettingsViewController.h"
#import "HNSwitchTableViewCell.h"
#import "HNShareSwitchGroupTableViewCell.h"
#import "HNLastUpdateTableViewCell.h"
#import "HNButtonTableViewCell.h"
#import <MessageUI/MessageUI.h>

#define kSTANDARD_WIDTH 300.0f

static NSString *const notificationCellIdentifier = @"notificationCellIdentifier";
static NSString *const shareGroupCellIdentifier = @"shareGroupCellIdentifier";
static NSString *const lastUpdateCellIdentifier = @"lastUpdateCellIdentifier";
static NSString *const adsCellIdentifier = @"adsCellIdentifier";
static NSString *const buttonsGroupCellIdentifier = @"buttonsGroupCellIdentifier";


typedef NS_OPTIONS(NSUInteger, SettingCellType) {
    SettingCellTypeNotificationSwitch = 0,
    //    SettingCellTypeShareGroupSwitch,
    SettingCellTypeAdsSwitch,
    SettingCellTypeLastUpdateLabel,
    SettingCellTypeButtonsGroup
};

@interface HNSettingsViewController () <
UITableViewDataSource,
UITabBarDelegate,
HNButtonGroupDelegate,
UIAlertViewDelegate,
MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation HNSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Settings";
    
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([HNSwitchTableViewCell class]) bundle:nil] forCellReuseIdentifier:notificationCellIdentifier];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([HNShareSwitchGroupTableViewCell class]) bundle:nil] forCellReuseIdentifier:shareGroupCellIdentifier];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([HNLastUpdateTableViewCell class]) bundle:nil] forCellReuseIdentifier:lastUpdateCellIdentifier];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([HNSwitchTableViewCell class]) bundle:nil] forCellReuseIdentifier:adsCellIdentifier];
    [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([HNButtonTableViewCell class]) bundle:nil] forCellReuseIdentifier:buttonsGroupCellIdentifier];
    
    self.tableview.tableFooterView = [UIView new];
    
    UIButton *sideMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sideMenuButton setImage:[UIImage imageNamed:@"side_menu_quicklist_icon"] forState:UIControlStateNormal];
    [sideMenuButton setImage:[UIImage imageNamed:@"side_menu_quicklist_icon_selected"] forState:UIControlStateHighlighted];
    [sideMenuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [sideMenuButton sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sideMenuButton];
}

- (void)showMenu {
    [self.sideMenuViewController presentMenuViewController];
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return SettingCellTypeButtonsGroup + 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    sectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0f];
    
    UILabel *sectionTitle = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, 300.0f, 44.0f)];
    sectionTitle.backgroundColor = [UIColor clearColor];
    sectionTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:10.0f];
    sectionTitle.textColor = [UIColor asbestosColor];
    sectionTitle.numberOfLines = 0;

    [sectionView addSubview:sectionTitle];
    
    NSString *titleText;
    switch (section) {
        case SettingCellTypeNotificationSwitch:
            titleText = @"We will never spam you, but if you want to be notified of breaking news and other important updates, leave this on";
            break;
        case SettingCellTypeLastUpdateLabel:
            titleText = @"";
            break;
        case SettingCellTypeAdsSwitch:
            titleText = @"We use adds to make up for our operational costs, support us by enabling ads, they are pretty I promise, and if you dont like them, just flick the switch";
            break;
        case SettingCellTypeButtonsGroup:
            titleText = @"";
            break;
        default:
            break;
    }

    sectionTitle.text = titleText;
    
    return sectionView;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case SettingCellTypeNotificationSwitch:{
            HNSwitchTableViewCell *switchCell =  (HNSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:notificationCellIdentifier];
            switchCell.titleLabel.text = @"Allow Notifications";
            cell = switchCell;
        }
            break;
        case SettingCellTypeLastUpdateLabel:
            cell = (HNLastUpdateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:lastUpdateCellIdentifier];
            break;
        case SettingCellTypeAdsSwitch:{
            HNSwitchTableViewCell *switchCell =  (HNSwitchTableViewCell *)[tableView dequeueReusableCellWithIdentifier:adsCellIdentifier];
            switchCell.titleLabel.text = @"Enable Ads";
            [switchCell.switchButton addTarget:self action:@selector(setAds:) forControlEvents:UIControlEventValueChanged];
           
           switchCell.switchButton.on =  ![[NSUserDefaults standardUserDefaults] valueForKey:@"enableAds"];
            cell = switchCell;
        }
            break;
        case SettingCellTypeButtonsGroup:{
            HNButtonTableViewCell *cellGroup = (HNButtonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:buttonsGroupCellIdentifier];
            cellGroup.delegate = self;
            cellGroup.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(tableView.bounds), 0, 0);
            cell = cellGroup;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 44.0f;
    switch (indexPath.section) {
        case SettingCellTypeNotificationSwitch:
            height = 44.0f;
            break;
        case SettingCellTypeLastUpdateLabel:
            height = 44.0f;
            break;
        case SettingCellTypeAdsSwitch:
            height = 44.0f;
            break;
        case SettingCellTypeButtonsGroup:
            height = 232.0f;
            break;
        default:
            break;
    }
    return height;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    CGFloat height = 44.0f;
    switch (section) {
        case SettingCellTypeNotificationSwitch:
            height = 44.0f;
            break;
        case SettingCellTypeLastUpdateLabel:
            height = 0.0f;
            break;
        case SettingCellTypeAdsSwitch:
            height = 45.0f;
            break;
        case SettingCellTypeButtonsGroup:
            height = 0.0f;
            break;
        default:
            break;
    }
    return height;

}

- (void)setAds:(id)sender {

    UISwitch *switchButton = (UISwitch *)sender;
    
    [[NSUserDefaults standardUserDefaults] setBool:switchButton.on forKey:@"enableAds"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma Group Button Delegate

- (void)clearCache:(id)sender {
    
    UIAlertView *clearCacheAlert = [[UIAlertView alloc] initWithTitle:@"Cache"
                                                              message:@"Clear all articles, and save some space on your device. This will also remove your saved favourites."
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Clear", nil];
    
    [clearCacheAlert show];
    
}

- (void)presentDonateSheet:(id)sender {
    
    UIAlertView *clearCacheAlert = [[UIAlertView alloc] initWithTitle:@"What!!"
                                                              message:@"Keep your coins you punny little human!"
                                                             delegate:self
                                                    cancelButtonTitle:@"Err..Ok"
                                                    otherButtonTitles: nil];
    
    [clearCacheAlert show];
}

- (void)presentFeedBackSheet:(id)sender {
    
    NSString *emailTitle = @"Your Feedback";
    NSString *messageBody = @"Let us know where we can improve";
    NSArray *toRecipents = @[@"feedback@habariapp.co.ke"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

#pragma mark - MFMail Delegate

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        return;
    }
    
    
}
@end
